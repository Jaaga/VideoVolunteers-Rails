class State < ActiveRecord::Base
  validates :state, presence: true, length: { maximum: 50 },
             uniqueness: { case_sensitive: false }
  validates :state_abb, presence: true, length: { maximum: 5 },
             uniqueness: { case_sensitive: false }
  validates :district, length: { maximum: 50 }, allow_blank: true

  before_save :capitalize_data


  private

    def capitalize_data
      self.state = state.split(' ').map(&:capitalize).join(' ')
      self.state_abb = state_abb.upcase
      self.district = district.split(' ').map(&:capitalize).join(' ')
    end
end
