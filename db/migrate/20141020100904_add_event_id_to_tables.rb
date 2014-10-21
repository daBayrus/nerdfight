class AddEventIdToTables < ActiveRecord::Migration
  def change
    add_column :teams,     :event_id, :integer
    add_column :questions, :event_id, :integer
    add_column :scores,    :event_id, :integer
  end
end
