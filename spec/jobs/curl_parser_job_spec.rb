require 'rails_helper'

RSpec.describe CurlParserJob, type: :job do
  include ActiveJob::TestHelper
  subject(:job) { described_class.perform_later(123) }

  let(:review) { create(:review, store_id: 2460286, opinion: 'dev') }

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

  before do
    allow(CurlParser).to receive(:new)
                           .with(review.attributes, 'creating')
                           .and_return(
                             CurlParser.new(review.attributes, 'creating')
                           )
    allow(CurlParser.new(review.attributes, 'creating'))
      .to receive(:exec).and_return([curl_cmd])

  end

  it 'queues the job' do
    expect { job }
      .to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end


  it 'calls and executes CurlParser service' do
    expect(CurlParser).to receive(:new).with(review.attributes, 'creating')
    expect(CurlParser.new(review.attributes, 'creating')).to receive(:exec)
    subject.perform(review, 'creating')
  end

  it 'calls CurlRunnerJob with each command obtained from the CurlParser' do
    expect(CurlRunnerJob).to receive(:perform_later).with(curl_cmd)
    subject.perform(review, 'creating')
  end
end
