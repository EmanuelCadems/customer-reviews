require 'acceptance_helper'
require 'timecop'
resource 'V1::Reviews', prefix: '/v1' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before do
    Timecop.freeze(Date.today.last_month.beginning_of_month.beginning_of_day)
    create_list(:review, 6, store_id: 1)
    Timecop.return
    create_list(:review, 4, store_id: 1)
    header 'Authorization', "Token token=#{ENV['USER_API_KEY']}"
  end

  context 'matching' do
    get '/v1/reviews?q[store_id_eq]=:store_id&q[created_at_gteq]=:from&' +
        'q[created_at_end_of_day_lteq]=:to' do
      let(:store_id) { 1 }
      let(:from)     { Date.today.beginning_of_month }
      let(:to)       { Date.today.end_of_month }

      example_request 'search by store_id & range of date' do
        explanation 'Searches a review by store_id and range of date'

        expect(status).to eq(200)

        response = JSON.parse(response_body, symbolize_names: true)

        expect(response.count).to eq(4)
      end
    end
  end

  context 'no-matching' do
    get '/v1/reviews?q[store_id_eq]=:store_id&q[created_at_gteq]=:from&' +
        'q[created_at_end_of_day_lteq]=:to' do
      let(:store_id) { 2 }
      let(:from)     { Date.today.beginning_of_month }
      let(:to)       { Date.today.end_of_month }

      example_request 'search by non-existent store_id & range of date' do
        explanation 'Shows 204'

        expect(status).to eq(204)
      end
    end
  end
end
