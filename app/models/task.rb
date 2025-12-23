class Task < ApplicationRecord
  belongs_to :user
  has_one :outline, dependent: :destroy
  has_many :notes, dependent: :destroy

end
