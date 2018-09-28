require 'acceptance_helper'

resource 'V1::Reviews', prefix: '/v1' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before do
    header 'Authorization', "Token token=#{ENV['USER_API_KEY']}"
  end

  let(:review) { create(:review) }

  context 'valid' do
    get '/v1/reviews/:id' do
      let(:id) { review.id }

      example_request 'show' do
        explanation 'Shows a review '

        expect(status).to eq(200)

        response = JSON.parse(response_body, symbolize_names: true)

        expect(response[:store_id]).to eq(review.store_id)
        expect(response[:order_id]).to eq(review.order_id)
        expect(response[:order_id]).to eq(review.order_id)
        expect(response[:user_id]).to eq(review.user_id)
        expect(response[:opinion]).to eq(review.opinion)
        expect(response[:score]).to eq(review.score)
      end
    end
  end

  context 'invalid' do
    get '/v1/reviews/:id' do
      let(:id) { 100 }

      example_request 'show a non-existent review' do
        explanation 'Shows 404'

        expect(status).to eq(404)
      end
    end
  end
end
