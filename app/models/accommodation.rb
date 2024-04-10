class Accommodation < ApplicationRecord
  belongs_to :trip

  validates :name, presence: true
  validates :address, presence: true
  validates :check_out, comparison: { greater_than: :check_in }
end
