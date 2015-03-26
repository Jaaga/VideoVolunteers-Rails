class Tracker < ActiveRecord::Base

  belongs_to :tracker_details, polymorphic: true

  validates :uid, presence: true, length: { maximum: 16 },
             uniqueness: { case_sensitive: false }
  validates_presence_of :state_name, :cc_name, :iu_theme, :description,
                        :story_type, :project, :campaign, :shoot_plan,
                        :story_pitch_date

  before_save :set_district_and_mentor


  private


    def set_district_and_mentor
      cc = Cc.find_by(full_name: self.cc_name)
      self.district = cc.district
      self.mentor = cc.mentor
    end
end
