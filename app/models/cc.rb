class Cc < ActiveRecord::Base
  belongs_to :state

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :state_name, presence: true, length: { maximum: 50 }
  validates :district, presence: true, length: { maximum: 50 }
  validates :phone, length: { maximum: 15 }
  validates :mentor, presence: true, length: { maximum: 50 }

  before_save :capitalize_data
  before_save :full_name_set
  before_save :phone_set

  private

    def capitalize_data
      self.first_name = first_name.split(' ').map(&:capitalize).join(' ')
      self.last_name = last_name.split(' ').map(&:capitalize).join(' ')
      self.district = district.split(' ').map(&:capitalize).join(' ')
      self.mentor = mentor.split(' ').map(&:capitalize).join(' ')
    end

    def full_name_set
      self.full_name = "#{ self.first_name } #{ self.last_name }"
    end

    def phone_set
      self.phone = phone.gsub(/[^0-9]/, "")
    end
end
