require 'rails_helper'

RSpec.describe CurlRunnerJob, type: :job do
  include ActiveJob::TestHelper
  subject(:job) { described_class.perform_later(123) }

  let(:review) { create(:review)}
  let(:curl_cmd) do
    <<-EOF
      curl --header "Content-Type: application/json" \
         --request POST \
         --data '{
            "store_id": "#{review.store_id}",
            "order_id": "#{review.order_id}",
            "user_id": "#{review.user_id}",
            "opinion": "#{review.opinion}",
            "score": "#{review.score}",
            "created_at": "#{review.created_at.iso8601(3)}",
            "updated_at": "#{review.updated_at.iso8601(3)}"
          }' \
         https://api.jsonbin.io/b
    EOF
  end

  it 'queues the job' do
    expect { job }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  it 'executes a curl command' do
    expect(Kernel).to receive(:system).with(curl_cmd)
    subject.perform(curl_cmd)
  end
end
