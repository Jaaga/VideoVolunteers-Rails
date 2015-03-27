class Tracker < ActiveRecord::Base

  belongs_to :state
  belongs_to :cc

  validates :uid, presence: true, length: { maximum: 16 },
             uniqueness: { case_sensitive: false }
  validates_presence_of :state_name, :cc_name, :iu_theme, :description,
                        :story_type, :project, :campaign, :shoot_plan,
                        :story_pitch_date

  before_save :set_district_and_mentor

  before_destroy :unlink_impact

  private


    def set_district_and_mentor
      cc = Cc.find_by(full_name: self.cc_name)
      self.district = cc.district
      self.mentor = cc.mentor
    end

    def unlink_impact
      if !self.impact_uid.blank? && !self.uid.include?('_impact')
        linked_tracker = Tracker.find_by(uid: self.impact_uid)
        linked_tracker.update_attribute(:original_uid, nil)
      elsif !self.original_uid.blank? && self.uid.include?('_impact')
        linked_tracker = Tracker.find_by(uid: self.original_uid)
        linked_tracker.update_attribute(:impact_uid, nil)
      end
    end
end
