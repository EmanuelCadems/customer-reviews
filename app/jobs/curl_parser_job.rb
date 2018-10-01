class CurlParserJob < ApplicationJob
  queue_as :default

  def perform(review, execute_after)
    result = CurlParser.new(review.attributes, execute_after).exec

    result.each do |curl_cmd|
      CurlRunnerJob.perform_later curl_cmd
    end
  end
end
