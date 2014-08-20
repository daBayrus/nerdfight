class CreateQuizzes < ActiveRecord::Migration
  def change
    create_table :quizzes do |t|
      t.column :winner, :integer

      t.timestamps
    end
  end
end
