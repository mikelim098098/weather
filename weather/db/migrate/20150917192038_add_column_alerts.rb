class AddColumnAlerts < ActiveRecord::Migration
  def change
    add_column :alerts, :title, :string
  end
end
