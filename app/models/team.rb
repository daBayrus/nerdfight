class Team < ActiveRecord::Base
  has_many :nerds
  has_many :users, through: :nerds
  has_many :questions

  validates :name, presence: true, uniqueness: true
  validates :nerds, presence: true
end
