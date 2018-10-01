class Review < ApplicationRecord
  acts_as_paranoid

  SCORES = (1..5).to_a

  validates :store_id, presence: true,
    uniqueness: { scope: [:order_id, :user_id] }
  validates :order_id, presence: true
  validates :user_id, presence: true
  validates :opinion, presence: true
  validates :score, presence: true,
    inclusion: { in: SCORES, message: "%{value} is not a valid score" }

  scope :by_store, -> (store_id) { where(store_id: store_id) }
  scope :between,  -> (from, to) {
    where(created_at: from&.to_date&.beginning_of_day..to&.to_date&.end_of_day)
  }
  scope :score_avg_by_store_and_period, -> (store_id, from, to) {
    by_store(store_id).between(from, to).average(:score)
  }

  after_create :notify_creation
  after_update :notify_updating
  after_destroy :notify_destroying

  private

  def notify_creation
    CurlParserJob.perform_later self, 'creating'
  end

  def notify_updating
    CurlParserJob.perform_later self, 'updating'
  end

  def notify_destroying
    CurlParserJob.perform_later self, 'destroying'
  end
end
