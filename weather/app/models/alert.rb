class Alert < ActiveRecord::Base
	belongs_to :user
  
  validates :title, :city_name, :alert_time, presence: true
  validate :correct_alert_time

  def correct_alert_time
    hours = ['05', '06', '07', '08', '09', '10', '11']
    if hours.include?(self.alert_time.strftime("%I"))
    else
      errors.add(:alert_time, "must be specified between 5am to 12pm")
    end
  end
end
