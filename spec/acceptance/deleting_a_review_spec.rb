require 'acceptance_helper'

resource 'V1::Reviews', prefix: '/v1' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'


  let(:review) { create(:review) }

  before do
    header 'Authorization', "Token token=#{ENV['MODERATOR_API_KEY']}"
  end

  context 'valid' do
    delete '/v1/reviews/:id' do
      let(:id)       { review.id }

      example_request 'delete' do
        explanation 'Deletes a review '

        expect(status).to eq(204)
      end
    end
  end

  context 'invalid' do
    delete '/v1/reviews/:id' do
      let(:id)       { 100 }

      example_request 'delete non-existent resource' do
        explanation 'returns not found'

        expect(status).to eq(404)
      end
    end
  end
end
