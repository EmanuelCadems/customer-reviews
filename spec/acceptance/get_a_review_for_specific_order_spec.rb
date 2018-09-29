require 'acceptance_helper'

resource 'V1::Reviews', prefix: '/v1' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before do
    header 'Authorization', "Token token=#{ENV['USER_API_KEY']}"
  end

  let(:review) { create(:review) }

  context 'matching' do
    get '/v1/reviews?q[order_id_eq]=:order_id&q[id_eq]=:id' do
      let(:order_id) { review.order_id }
      let(:id) { review.id }

      example_request 'search review by order_id & id' do
        explanation 'Searchs a review by order_id and its id'

        expect(status).to eq(200)

        response = JSON.parse(response_body, symbolize_names: true)

        review_response = response.first
        expect(review_response[:store_id]).to eq(review.store_id)
        expect(review_response[:order_id]).to eq(review.order_id)
        expect(review_response[:order_id]).to eq(review.order_id)
        expect(review_response[:user_id]).to eq(review.user_id)
        expect(review_response[:opinion]).to eq(review.opinion)
        expect(review_response[:score]).to eq(review.score)
      end
    end
  end

  context 'no-matching' do
    get '/v1/reviews?q[order_id_eq]=:order_id&q[id_eq]=:id' do
      let(:order_id) { review.order_id }
      let(:id) { 100 }

      example_request 'search review by order_id & non-existent id' do
        explanation 'Shows 204'

        expect(status).to eq(204)
      end
    end
  end
end
