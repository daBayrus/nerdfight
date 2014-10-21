class AddAnswerToScores < ActiveRecord::Migration
  def change
    add_column :scores,    :answer, :string
  end
end
