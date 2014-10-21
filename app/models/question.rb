class Question < ActiveRecord::Base
  belongs_to :event
  belongs_to :team
  belongs_to :quiz

  has_many :scores

  validates :content, presence: true
  validates :answer, presence: true

  scope :unasked, -> { where(asked: false) }
  scope :asked, -> { where(asked: true) }
end
