class Review < ApplicationRecord
  SCORES = (1..5).to_a
  validates :store_id, presence: true, uniqueness: { scope: [:order_id, :user_id] }
  validates :order_id, presence: true
  validates :user_id, presence: true
  validates :opinion, presence: true
  validates :score, presence: true, inclusion: { in: SCORES, message: "%{value} is not a valid score" }
end

