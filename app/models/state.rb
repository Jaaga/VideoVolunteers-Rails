class State < ActiveRecord::Base
  has_many :ccs
  has_many :trackers

  validates :name, presence: true, length: { maximum: 50 },
             uniqueness: { case_sensitive: false }
  validates :state_abb, presence: true, length: { maximum: 2 },
             uniqueness: { case_sensitive: false }

  before_save :capitalize_data


  private

    # Capitalizes the state's name and upcases the state's abbreviation.
    def capitalize_data
      self.name = name.split(' ').map(&:capitalize).join(' ')
      self.state_abb = state_abb.upcase
    end
end
