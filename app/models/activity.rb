class Activity < ApplicationRecord
   belongs_to :trip

   validates :activity_type, presence: true
   validates :address, presence: true
end
