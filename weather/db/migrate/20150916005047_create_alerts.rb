class CreateAlerts < ActiveRecord::Migration
  def change
    create_table :alerts do |t|
      t.string :city_name
      t.datetime :alert_time

      t.timestamps null: false
    end
  end
end
