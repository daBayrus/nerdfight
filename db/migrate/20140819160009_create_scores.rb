class CreateScores < ActiveRecord::Migration
  def change
    create_table :scores do |t|
      t.belongs_to :team
      t.belongs_to :question
      t.integer :points
      t.integer :total

      t.timestamps
    end
  end
end
