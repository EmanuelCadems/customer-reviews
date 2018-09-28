require 'acceptance_helper'

resource 'V1::Reviews', prefix: '/v1' do

  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  let(:review) { create(:review) }

  context 'valid api_key' do
    before do
      header 'Authorization', "Token token=#{ENV['MODERATOR_API_KEY']}"
    end

    get '/v1/reviews/:id' do
      let(:id) { review.id }

      example_request 'show with a valid moderator api_key' do
        explanation 'Shows a review '

        expect(status).to eq(200)
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

      example_request 'create with a valid moderator api_key' do
        explanation 'Creates a new review '

        expect(status).to eq(201)
      end
    end

    delete '/v1/reviews/:id' do
      let(:id)       { review.id }

      example_request 'delete with a valid moderator api_key' do
        explanation 'Deletes a review '

        expect(status).to eq(204)
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

      example_request 'update' do
        explanation 'Updates a review '

        expect(status).to eq(200)
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
