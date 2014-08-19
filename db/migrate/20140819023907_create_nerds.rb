class CreateNerds < ActiveRecord::Migration
  def change
    create_table :nerds do |t|
      t.belongs_to :team
      t.belongs_to :user

      t.timestamps
    end
  end
end
