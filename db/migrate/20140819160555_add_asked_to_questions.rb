class AddAskedToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :asked, :boolean, default: false
  end
end
