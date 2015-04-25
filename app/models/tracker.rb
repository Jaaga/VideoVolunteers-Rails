class Tracker < ActiveRecord::Base
  attr_accessor :cc_impact_action
  require 'csv'

  YESNO = %w(Yes No)

  belongs_to :state
  belongs_to :cc

  before_save :set_district_and_mentor
  before_save :impact_errors
  #before_save :set_production_status, :proper_uid
  after_save  :set_cc_dates
  before_destroy :unlink_impact

  validates :uid, presence: true, length: { maximum: 16 },
             uniqueness: { case_sensitive: false }
  validates_presence_of :state_name, :cc_name, :iu_theme, :description,
                        :story_type, :project, :campaign, :shoot_plan,
                        :story_pitch_date

  validates_numericality_of :people_involved, only_integer: true,
                            allow_blank: true
  validates_numericality_of :people_impacted, only_integer: true,
                            allow_blank: true
  validates_numericality_of :villages_impacted, only_integer: true,
                            allow_blank: true
  validates_numericality_of :screening_headcount, only_integer: true,
                            allow_blank: true
  validates_numericality_of :officials_at_screening_number, only_integer: true,
                            allow_blank: true

  validates :high_potential, inclusion: YESNO, allow_blank: true
  validates :impact_possible, inclusion: YESNO, allow_blank: true
  validates :impact_achieved, inclusion: YESNO, allow_blank: true
  validates :screening_done, inclusion: YESNO, allow_blank: true
  validates :officials_at_screening, inclusion: YESNO, allow_blank: true
  validates :impact_video_approved, inclusion: YESNO, allow_blank: true


  include PgSearch
  pg_search_scope :search_any_word,
                  :against => [:uid, :description, :cc_name, :state_name, :shoot_plan, 
                    :production_status, :iu_theme, :footage_received_from_cc_date, :youtube_date,
                    :youtube_url, :video_title],
                  :using => {
                    :tsearch => {:any_word => true},
                    :trigram => {
                      :only => [:uid, :description, :shoot_plan],
                      :threshold => 0.3
                    }
                  }



  # def Tracker.show_to_sc(state, view)
  #   if state == 'ROI'
  #     # Get a list of all ROI state IDs and find the trackers based on this list
  #     @states = State.where(roi: true)
  #     roi_states = @states.map{ |state| state.id }.to_a
  #     if view == 'pitched'
  #       @trackers = Tracker.where("state_id IN (?) AND footage_recieved = ? AND proceed_with_edit_and_payment != ?", roi_states, false, 'On hold').order("updated_at DESC")
  #     elsif view == 'produced'
  #       @trackers = Tracker.where("state_id IN (?) AND footage_recieved = ? AND proceed_with_edit_and_payment = ?", roi_states, true, 'Cleared').order("updated_at DESC")
  #     elsif view == 'hold'
  #       @trackers = Tracker.where("state_id IN (?) AND footage_recieved = ? AND proceed_with_edit_and_payment = ?", roi_states, true, 'On hold').order("updated_at DESC")
  #     end
  #   else
  #     if view == 'pitched'
  #       @trackers = Tracker.where("state_name = ? AND footage_recieved = ? AND proceed_with_edit_and_payment != ?", "#{state}", false, 'On hold').order("updated_at DESC")
  #     elsif view == 'produced'
  #       @trackers = Tracker.where("state_name = ? AND footage_recieved = ? AND proceed_with_edit_and_payment = ?", "#{state}", true, 'Cleared').order("updated_at DESC")
  #       # @title_header = "Raw Footage Has Not Been Reviewed and Footage is in State"
  #     elsif view == 'hold'
  #       @trackers = Tracker.where("state_name = ? AND footage_recieved = ? AND proceed_with_edit_and_payment = ?", "#{state}", true, 'On hold').order("updated_at DESC")
  #       # @title_header = "Edit and Payment is on Hold"
  #     end
  #   end
  # end

  def self.show_to_editor(view, name)
    if view == 'edit'
      @trackers = Tracker.where("editor_currently_in_charge = ? AND production_status = ?", "#{name}", "Footage to edit").order("updated_at DESC")
    elsif view == 'hold'
      @trackers = Tracker.where("editor_currently_in_charge = ? AND production_status = ?", "#{name}", "Edit on hold").order("updated_at DESC")
    elsif view == 'done'
      @trackers = Tracker.where("editor_currently_in_charge = ? AND edit_status = ?", "#{name}", "Done").order("updated_at DESC")
    elsif view == 'clean'
      @trackers = Tracker.where("rough_cut_editor = ? AND production_status = ?", "#{name}", "Rough cuts to clean").order("updated_at DESC")
    elsif view == 'finalize'
      @trackers = Tracker.where("rough_cut_editor = ? AND production_status = ?", "#{name}", "To finalize and upload").order("updated_at DESC")
    end
  end

  def self.to_csv(options = {})
    CSV.generate(options) do |csv|
      csv << column_names
      all.each do |tracker|
        csv << tracker.attributes.values_at(*column_names)
      end
    end
  end


  def self.monthly_report(month, year, status="Story pitched (no footage yet)", state = "%")
    if status == "Story pitched (no footage yet)"
      @trackers = Tracker.where('extract(month from story_pitch_date) = ? AND extract(year from story_pitch_date) = ? AND state_name LIKE ?', "#{month}", "#{year}", "#{state}")
    elsif status == "Footage received"
      @trackers = Tracker.where('extract(month from footage_received_from_cc_date) = ? AND extract(year from footage_received_from_cc_date) = ? AND state_name LIKE ?', "#{month}", "#{year}", "#{state}")
    elsif status == "Footage on hold"
      @trackers = Tracker.where('extract(month from footage_check_date) = ? AND extract(year from footage_check_date) = ? AND state_name LIKE ? AND production_status = ?', "#{month}", "#{year}", "#{state}", "Footage on hold")
    elsif status == "Footage approved for payment"
      @trackers = Tracker.where('extract(month from proceed_with_edit_and_payment_date) = ? AND extract(year from proceed_with_edit_and_payment_date) = ? AND state_name LIKE ?', "#{month}", "#{year}", "#{state}")
    elsif status == "Footage to edit"
      @trackers = Tracker.where('extract(month from proceed_with_edit_and_payment_date) = ? AND extract(year from proceed_with_edit_and_payment_date) = ? AND state_name LIKE ? AND production_status = ?', "#{month}", "#{year}", "#{state}", "Footage to edit")
    elsif status == "Edit on hold"
      @trackers = Tracker.where('extract(month from proceed_with_edit_and_payment_date) = ? AND extract(year from proceed_with_edit_and_payment_date) = ? AND state_name LIKE ? AND edit_status = ?', "#{month}", "#{year}", "#{state}", "On hold")
    elsif status == "Edit Done"
      @trackers = Tracker.where('extract(month from state_edit_date) = ? AND extract(year from state_edit_date) = ? AND state_name LIKE ? AND edit_status = ?', "#{month}", "#{year}", "#{state}", "Done")
    elsif status == "Rough cut sent to Goa"
      @trackers = Tracker.where('extract(month from rough_cut_sent_to_goa_date) = ? AND extract(year from rough_cut_sent_to_goa_date) = ? AND state_name LIKE ?', "#{month}", "#{year}", "#{state}")
    elsif status == "Rough cuts to clean"
      @trackers = Tracker.where('extract(month from edit_received_in_goa_date) = ? AND extract(year from edit_received_in_goa_date) = ? AND state_name LIKE ? AND production_status = ?', "#{month}", "#{year}", "#{state}", "Rough cuts to clean")
    elsif status == "Rough cuts to review"
      @trackers = Tracker.where('extract(month from edit_received_in_goa_date) = ? AND extract(year from edit_received_in_goa_date) = ? AND state_name LIKE ? AND production_status = ?', "#{month}", "#{year}", "#{state}", "Rough cuts to review")
    elsif status == "To finalize and upload"
      @trackers = Tracker.where('extract(month from rough_cut_review_date) = ? AND extract(year from rough_cut_review_date) = ? AND state_name LIKE ? AND production_status = ?', "#{month}", "#{year}", "#{state}", "To finalize and upload")
    elsif status == "Uploaded"
      @trackers = Tracker.where('extract(month from youtube_date) = ? AND extract(year from youtube_date) = ? AND state_name LIKE ? AND production_status = ?', "#{month}", "#{year}", "#{state}", "Uploaded")
    elsif status == "Problem video"
      @trackers = Tracker.where('extract(month from footage_received_from_cc_date) = ? AND extract(year from footage_received_from_cc_date) = ? AND state_name LIKE ? AND production_status = ?', "#{month}", "#{year}", "#{state}", "Problem video")
    end
  end


  private

    # Sets the impact information to nil if there's is an error saving it. Errors
    # will render the same page, but .save might not have failed. This will make
    # sure the values saved are nil.
    def impact_errors
      def nil_set
        self.is_impact = nil
        self.original_uid = nil
        self.no_original_uid = nil
      end

      if self.is_impact == '1' && self.no_original_uid.blank? && self.original_uid.blank?
        nil_set
      elsif self.is_impact == '0' && !self.no_original_uid.blank? && !self.original_uid.blank?
        nil_set
      elsif self.is_impact == '1' && !self.no_original_uid.blank? && !self.original_uid.blank?
        nil_set
      elsif self.is_impact == '0' && !self.no_original_uid.blank? && self.original_uid.blank?
        nil_set
      elsif self.is_impact == '0' && self.no_original_uid.blank? && !self.original_uid.blank?
        nil_set
      end
    end

    # District and mentor columns are directly set from CC information.
    def set_district_and_mentor
      unless self.cc.blank?
        cc = self.cc
        self.district = cc.district
        self.mentor = cc.mentor
      end
    end

    # CC stats are set based on values from associated trackers. Values are only
    # assigned and then saved once (instead of using update_attribute). The
    # newest date will be the most up-to-date.
    def set_cc_dates
      unless self.cc.blank?
        if story_pitch_date_changed?
          self.cc.assign_attributes(last_pitched_story_idea_date: story_pitch_date)
        end
        if footage_check_date?
          self.cc.assign_attributes(last_issue_video_made_date: footage_check_date)
        end
        if impact_achieved_changed? && impact_achieved == 'yes'
          self.cc.assign_attributes(last_impact_achieved_date: Date.today)
        end
        if footage_received_from_cc_date_changed?
          self.cc.assign_attributes(last_issue_video_sent_date: footage_received_from_cc_date)
        end
        if impact_video_status_changed? && impact_video_status == 'Completed'
          self.cc.assign_attributes(last_impact_video_made_date: Date.today)
        end

        self.cc.save
      end
    end

    # If a linked tracker is destroyed, the link will be broken. Impact videos
    # need a reason for not having an original_uid set.
    def unlink_impact
      if !self.impact_uid.blank? && !self.uid.include?('_impact')
        linked_tracker = Tracker.find_by(uid: self.impact_uid)
        linked_tracker.update_attributes(original_uid: nil,
                                      no_original_uid: 'Original was deleted.')
      elsif !self.original_uid.blank? && self.uid.include?('_impact')
        linked_tracker = Tracker.find_by(uid: self.original_uid)
        linked_tracker.update_attribute(:impact_uid, nil)
      end
    end

    def proper_uid
      if (self.is_impact.blank? || self.is_impact == false) 
        if self.footage_recieved && self.proceed_with_edit_and_payment == 'Cleared'
          self.tracker_type = "Issue"
          self.uid = "#{self.state.state_abb}_"+self.uid.gsub(/[^0-9]/,"")
        else
          self.tracker_type = "Story"
          self.uid = "#{self.state.state_abb}_"+self.uid.gsub(/[^0-9]/,"")+"_story"
        end
      else
        self.tracker_type = "Impact"
        self.uid = "#{self.state.state_abb}_"+self.uid.gsub(/[^0-9]/,"")+"_impact"
      end
    end

    def set_production_status
      if self.footage_recieved == false
        self.production_status = "Story pitched (no footage yet)"
      end
      if self.footage_recieved == true
        self.production_status = "Footage received"
      end
      if self.footage_recieved == true && self.proceed_with_edit_and_payment == 'On hold'
        self.production_status = "Footage on hold"
      end
      if self.footage_recieved == true && self.proceed_with_edit_and_payment == 'Cleared'
        self.proceed_with_edit_and_payment_date = Date.today.to_s
        self.production_status = "Footage approved for payment"
      end
      if self.footage_recieved == true && self.editor_currently_in_charge.blank? != true
        self.production_status = "Footage to edit"
      end
      if self.footage_recieved == true && self.editor_currently_in_charge.blank? != true && self.edit_status == "On hold"
        self.production_status = "Edit on hold"
      end
      if self.footage_recieved == true && self.editor_currently_in_charge.blank? != true && self.edit_status == "Done"
        self.production_status = "Edit Done"
      end
      if self.footage_recieved == true && (self.edit_status == "Done" || self.edit_status == "t") && self.rough_cut_sent_to_goa == true
        self.production_status = "Rough cut sent to Goa"
        self.office_responsible = "HQ"
      end
      if self.edit_received_in_goa_date.blank? == false && (self.edit_status == "Done" || self.edit_status == "t")
        self.production_status = "Rough cuts to clean"
      end
      if self.rough_cut_cleaned == true && self.rough_cut_reviewed == false
        self.production_status = "Rough cuts to review"
      end
      if self.rough_cut_cleaned == true && self.rough_cut_reviewed == true
        self.production_status = "To finalize and upload"
      end
      if self.rough_cut_reviewed == true && self.uploaded == true
        self.production_status = "Uploaded"
      end
      if self.edit_status == "Problem video"
        self.production_status = "Problem video"
      end
    end

end
