class Outline < ApplicationRecord
  belongs_to :task

  validates :contents, presence: true
end
