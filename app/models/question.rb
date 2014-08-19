class Question < ActiveRecord::Base
  belongs_to :team
  has_many :scores

  validates :content, presence: true
  validates :answer, presence: true
end
