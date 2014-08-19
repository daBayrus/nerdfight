class User < ActiveRecord::Base
  has_many :nerds
  has_one :team, through: :nerds

  validates :name, presence: true
end
