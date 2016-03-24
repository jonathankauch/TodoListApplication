class Task < ActiveRecord::Base
  attr_accessible :content, :status

  validates :content, presence: true

  scope :in_progress, -> { where(status: 1) }
  scope :completed, -> { where(status: 0) }
end
