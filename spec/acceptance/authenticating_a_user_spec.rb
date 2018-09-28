require 'acceptance_helper'

resource 'V1::Reviews', prefix: '/v1' do

  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:review) { create(:review) }

  context 'valid api_key' do
    before do
      header 'Authorization', "Token token=#{ENV['USER_API_KEY']}"
    end

    get '/v1/reviews/:id' do
      let(:id) { review.id }

      example_request 'show with a valid api_key' do
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

  context 'invalid api_key' do
    before do
      header 'Authorization', 'Token token=invalid'
    end

    get '/v1/reviews/:id' do
      let(:id) { review.id }
      example_request 'show with invalid api_key' do
        expect(status).to eq(401)
      end
    end

    post '/v1/reviews' do
      parameter :store_id, 'Store ID', scope: :review, required: true,
                                                       type: :integer
      parameter :order_id, 'Order ID', scope: :review, required: true,
                                                       type: :integer
      parameter :user_id, 'User ID', scope: :review, required: true,
                                                     type: :integer
      parameter :opinion, 'Opinion', scope: :review, required: true,
                                                     type: :string
      parameter :score, "Score", scope: :review, required: true, type: :integer,
        minimum: Review::SCORES.min, maximum: Review::SCORES.max,
        default: Review::SCORES.max

      let(:store_id) { 1 }
      let(:order_id) { 1 }
      let(:user_id) { 1 }
      let(:opinion) { 'Good food and service' }
      let(:score) { 5 }

      let(:raw_post) { params.to_json }

      example_request 'create with invalid api_key' do
        expect(status).to eq(401)
      end
    end

    patch '/v1/reviews/:id' do
      parameter :store_id, 'Store ID', scope: :review, required: true,
                                                       type: :integer
      parameter :order_id, 'Order ID', scope: :review, required: true,
                                                       type: :integer
      parameter :user_id, 'User ID', scope: :review, required: true,
                                                     type: :integer
      parameter :opinion, 'Opinion', scope: :review, required: true,
                                                     type: :string
      parameter :score, "Score", scope: :review, required: true, type: :integer,
        minimum: Review::SCORES.min, maximum: Review::SCORES.max,
        default: Review::SCORES.max

      let(:id)       { review.id }
      let(:store_id) { 1 }
      let(:order_id) { 1 }
      let(:user_id)  { 1 }
      let(:opinion)  { 'Good food and service' }
      let(:score)    { 5 }

      let(:raw_post) { params.to_json }

      example_request 'update with invalid api_key' do
        expect(status).to eq(401)
      end
    end
  end

  context 'invalid role' do
    before do
      header 'Authorization', "Token token=#{ENV['USER_API_KEY']}"
    end

    delete '/v1/reviews/:id' do
      let(:id)       { review.id }

      example_request 'delete with invalid api_key' do

        expect(status).to eq(401)
      end
    end
  end
end
