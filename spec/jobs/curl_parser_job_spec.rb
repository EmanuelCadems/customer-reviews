require 'rails_helper'

RSpec.describe CurlParserJob, type: :job do
  include ActiveJob::TestHelper
  subject(:job) { described_class.perform_later(123) }

  let(:review) { create(:review, store_id: 2460286, opinion: 'dev') }

  before do
    allow(CurlParser).to receive(:new)
                           .with(review.attributes, 'creating')
                           .and_return(
                             CurlParser.new(review.attributes, 'creating')
                           )
    allow(CurlParser.new(review.attributes, 'creating'))
      .to receive(:exec).and_return([])

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
end
