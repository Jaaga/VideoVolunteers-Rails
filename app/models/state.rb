class State < ActiveRecord::Base
  has_many :ccs
  has_many :trackers

  validates :name, presence: true, length: { maximum: 50 },
             uniqueness: { case_sensitive: false }
  validates :state_abb, presence: true, length: { maximum: 2 },
             uniqueness: { case_sensitive: false }

  before_save :capitalize_data
  before_save :modify_associations


  private

    # Capitalizes the state's name and upcases the state's abbreviation.
    def capitalize_data
      self.name = name.split(' ').map(&:capitalize).join(' ')
      self.state_abb = state_abb.upcase
    end

    def modify_associations
      unless self.ccs.blank?
        self.ccs.each do |cc|
          cc.update_attribute(:state_name, self.name)
          cc.update_attribute(:state_abb, self.state_abb)
        end

        # Decided not to modify UID prefix as that can cause a lot of tracking
        # issues (for example, if the UID's are being used as references with
        # outside sources).
        self.trackers.each do |tracker|
          tracker.update_attribute(:state_name, self.name)
        end
      end
    end
end
