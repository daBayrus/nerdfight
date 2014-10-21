class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.datetime :duration, null: false
      t.boolean :pooled_questions, default: false

      t.timestamps
    end
  end
end
