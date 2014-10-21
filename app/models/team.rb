class Team < ActiveRecord::Base
  belongs_to :event

  has_many :nerds
  has_many :users, through: :nerds
  has_many :questions
  has_many :scores

  validates :name, presence: true, uniqueness: true
  validates :nerds, presence: true

  def members
    members = []
    self.users.each do |u|
      members << u.name
    end
    members
  end
end
