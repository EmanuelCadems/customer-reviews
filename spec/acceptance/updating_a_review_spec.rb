require 'acceptance_helper'

resource 'V1::Reviews', prefix: '/v1' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'


  let(:review) { create(:review) }

  before do
    header 'Authorization', "Token token=#{ENV['USER_API_KEY']}"
  end

  context 'valid' do
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
      let(:store_id) { nil }
      let(:order_id) { nil }
      let(:user_id)  { nil }
      let(:opinion)  { nil }
      let(:score)    { 6 }

      let(:raw_post) { params.to_json }

      example_request 'update invalid score and empty values' do
        explanation 'Does not update a review with empty values '

        expect(status).to eq(422)

        errors = JSON.parse(response_body, symbolize_names: true)

        expect(errors[:store_id]).to include("can't be blank")
        expect(errors[:order_id]).to include("can't be blank")
        expect(errors[:user_id]).to include("can't be blank")
        expect(errors[:opinion]).to include("can't be blank")
        expect(errors[:score]).to include("#{score} is not a valid score")
      end
    end

    patch '/v1/reviews/:id' do
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

      let(:id)       { review.id }
      let(:store_id) { 1 }
      let(:order_id) { 1 }
      let(:user_id)  { 1 }
      let(:opinion)  { 'Good food and service' }
      let(:score)    { 1 }

      let(:raw_post) { params.to_json }

      example_request 'update invalid score a review already scored' do
        explanation 'Does not update a review that already was scored '

        expect(status).to eq(422)

        errors = JSON.parse(response_body, symbolize_names: true)

        expect(errors[:store_id]).to include("has already been taken")
      end
    end
    patch '/v1/reviews/:id' do
      let(:id)       { 100 }

      let(:raw_post) { params.to_json }

      example_request 'update non-existent resource' do
        explanation 'Returns not found '

        expect(status).to eq(404)
      end
    end
  end
end
