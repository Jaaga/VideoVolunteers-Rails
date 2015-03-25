class Tracker < ActiveRecord::Base

  belongs_to :tracker_details, polymorphic: true

  validates :uid, presence: true, length: { maximum: 16 },
             uniqueness: { case_sensitive: false }
  validates_presence_of :state_name, :cc_name, :iu_theme, :description,
                        :story_type, :project, :campaign, :shoot_plan,
                        :story_pitch_date
end
