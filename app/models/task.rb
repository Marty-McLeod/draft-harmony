class Task < ApplicationRecord
  belongs_to :user

  has_one :outline, dependent: :destroy
  has_many :notes, dependent: :destroy

  # Allo nested attributes for notes
  accepts_nested_attributes_for :notes, allow_destroy: true

  # Mandates that at least a title and gen. prompt text must exist
  validates :title, presence: true
  validates :synopsis, presence: true
  
end
