class State < ActiveRecord::Base
  validates_presence_of :state
  validates_presence_of :state_abb

  before_save :capitalize_data


  private

    def capitalize_data
      self.state = state.split(' ').map(&:capitalize).join(' ')
      self.state_abb = state_abb.upcase
      self.district = district.split(' ').map(&:capitalize).join(' ')
    end
end
