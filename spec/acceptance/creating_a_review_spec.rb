require 'acceptance_helper'

resource 'V1::Reviews', prefix: '/v1' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before do
    header 'Authorization', "Token token=#{ENV['API_KEY']}"
  end

  context 'valid' do
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

      example_request 'create' do
        explanation 'Creates a new review '

        expect(status).to eq(201)

        review = JSON.parse(response_body, symbolize_names: true)

        expect(review[:store_id]).to eq(store_id)
        expect(review[:order_id]).to eq(order_id)
        expect(review[:order_id]).to eq(order_id)
        expect(review[:user_id]).to eq(user_id)
        expect(review[:opinion]).to eq(opinion)
        expect(review[:score]).to eq(score)
      end
    end
  end

  context 'invalid' do
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

      let(:score) { 6 }

      let(:raw_post) { params.to_json }

      example_request 'create invalid score and empty values' do
        explanation 'Does not create a review with empty values '

        expect(status).to eq(422)

        errors = JSON.parse(response_body, symbolize_names: true)

        expect(errors[:store_id]).to include("can't be blank")
        expect(errors[:order_id]).to include("can't be blank")
        expect(errors[:user_id]).to include("can't be blank")
        expect(errors[:opinion]).to include("can't be blank")
        expect(errors[:score]).to include("#{score} is not a valid score")
      end
    end

    post '/v1/reviews' do
      before do
        create(:review, store_id: 1, order_id: 1, user_id: 1)
      end
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
      let(:score) { 1 }

      let(:raw_post) { params.to_json }

      example_request 'create invalid score a review already scored' do
        explanation 'Does not create a review that already was scored '

        expect(status).to eq(422)

        errors = JSON.parse(response_body, symbolize_names: true)

        expect(errors[:store_id]).to include("has already been taken")
      end
    end
  end
end
