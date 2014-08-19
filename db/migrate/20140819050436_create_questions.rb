class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|
      t.belongs_to :team
      t.string :content, null: false
      t.string :answer, null: false
      t.integer :points, null: false

      t.timestamps
    end
  end
end
