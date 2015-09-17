class AlertTable < ActiveRecord::Migration
  def change
  	change_column :alerts, :alert_time, :time
  end
end
