class CurlRunnerJob < ApplicationJob
  queue_as :default

  def perform(curl_cmd)
    Kernel.system(curl_cmd)
  end
end
