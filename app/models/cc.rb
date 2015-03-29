class Cc < ActiveRecord::Base
  # Included for the name_modifier method.
  include CcsHelper

  belongs_to :state
  has_many :trackers

  before_save :capitalize_data
  before_save :full_name_set
  before_save :phone_set
  before_save :modify_associations

  validates :first_name, presence: true, length: { maximum: 50 }
  validates :last_name, presence: true, length: { maximum: 50 }
  validates :state_name, presence: true
  validates :district, presence: true, length: { maximum: 50 }
  # So that max five phone numbers can be saved with commas and whitespace
  validates :phone, length: { maximum: 60 }
  validates :mentor, presence: true, length: { maximum: 50 }

  private

    # Capitalizes the column data from the capitalize array.
    def capitalize_data
      capitalize = ['first_name', 'last_name', 'district', 'mentor']
      capitalize.each do |column|
        self.send(:"#{ column }=", cc_name_modifier(self.send(:"#{ column }")))
      end
    end

    # Sets the full name based on the given first and last name
    # after capitalization.
    def full_name_set
      self.full_name = "#{ self.first_name } #{ self.last_name }"
    end

    # Removes any characters that aren't digits from 0-9 from the
    # given phone number.
    def phone_set
      self.phone = phone.gsub(/[^0-9\,\s]/, "") unless self.phone.nil?
    end

    # Re-associates CC and changes the data of its associations if its name
    # or state changes.
    def modify_associations
      unless self.trackers.blank?
        self.trackers.each do |tracker|
          tracker.assign_attributes(cc_name: self.full_name,
                                    district: self.district,
                                    mentor: self.mentor)
        end
      end

      if self.state_id_changed?
        state = State.find(self.state_id)
        self.assign_attributes(state: state,
                               state_name: state.name,
                               state_abb: state.state_abb)
      end
    end
end
