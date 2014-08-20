class AddQuizColumnToTables < ActiveRecord::Migration
  def change
    add_column :questions, :quiz_id, :integer
    add_column :scores,    :quiz_id, :integer
    add_column :teams,     :quiz_id, :integer
  end
end
