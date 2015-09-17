class Alert < ActiveRecord::Base
	belongs_to :user
  
  validates :title, :city_name, :alert_time, presence: true

end
