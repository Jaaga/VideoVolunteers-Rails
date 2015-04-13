class Tracker < ActiveRecord::Base
  attr_accessor :cc_impact_action

  YESNO = %w(Yes No)

  belongs_to :state
  belongs_to :cc

  before_save :set_district_and_mentor
  before_save :impact_errors, :proper_uid
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

  def Tracker.show_to_editor(view, name)
    if view == 'edit'
      @trackers = Tracker.where("editor_currently_in_charge = ?", "#{name}").order("updated_at DESC")
    elsif view == 'finalize'
      @trackers = Tracker.where("editor_currently_in_charge = ? AND finalized_date IS NOT NULL", "#{name}").order("updated_at DESC")
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
      if (self.is_impact == nil || self.is_impact == false) 
        if self.footage_recieved == true 
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

end

