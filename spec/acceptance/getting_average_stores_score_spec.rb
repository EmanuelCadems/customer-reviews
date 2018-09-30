require 'acceptance_helper'

resource 'V1::StoresScore', prefix: '/v1' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:bad_review)  { create(:review, score: 1, store_id: 1) }
  let(:good_review) { create(:review, score: 4, store_id: 1) }

  let(:reviews_last_month) do
    create_list(:review, 6, :last_month, store_id: 1)
  end

  before do
    reviews_last_month
    bad_review
    good_review

    header 'Authorization', "Token token=#{ENV['USER_API_KEY']}"
  end

  context 'with matching' do
    get '/v1/stores_score/:id?from=:from&to=:to' do
      let(:id) { 1 }
      let(:from)     { Date.today.beginning_of_month }
      let(:to)       { Date.today.end_of_month }

      example_request 'average store score' do
        explanation 'Shows a average store score '

        expect(status).to eq(200)

        response = JSON.parse(response_body, symbolize_names: true)

        expect(response[:avg]).to eq('2.5')
      end
    end
  end

  context 'without matching' do
    get '/v1/stores_score/:id?from=:from&to=:to' do
      let(:id) { 100 }
      let(:from) { nil }
      let(:to) { nil }

      example_request 'show a non-existent store' do
        explanation 'Shows 204'

        expect(status).to eq(204)
      end
    end
  end
end

