class CurlParserJob < ApplicationJob
  queue_as :default

  def perform(review, execute_after)
    result = CurlParser.new(review.attributes, execute_after).exec
  end
end
