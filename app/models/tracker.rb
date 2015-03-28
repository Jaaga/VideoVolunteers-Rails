class Tracker < ActiveRecord::Base

  YESNO = %w(yes no)

  belongs_to :state
  belongs_to :cc

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
  validates :cleared_for_edit, inclusion: YESNO, allow_blank: true
  validates :impact_video_approved, inclusion: YESNO, allow_blank: true

  before_save :set_district_and_mentor

  before_destroy :unlink_impact

  private


    def set_district_and_mentor
      cc = self.cc
      self.district = cc.district
      self.mentor = cc.mentor
    end

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
end
