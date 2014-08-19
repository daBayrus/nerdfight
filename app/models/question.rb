class Question < ActiveRecord::Base
  belongs_to :team

  validates :content, presence: true
  validates :answer, presence: true
end
