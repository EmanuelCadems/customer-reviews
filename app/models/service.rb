class Service < ApplicationRecord
  enum execute_after: [ :creating, :updating, :destroying, :crud ]

  validates :name, presence: true
  validates :curl_cmd, presence: true
  validates :execute_after, presence: true
end
