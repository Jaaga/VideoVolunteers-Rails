class Tracker < ActiveRecord::Base

  validates :uid, presence: true, length: { maximum: 10 },
             uniqueness: { case_sensitive: false }
  validates_presence_of :state_name
  validates_presence_of :cc_name
end
