require 'acceptance_helper'

resource 'V1::Services', prefix: '/v1' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'

  before do
    header 'Authorization', "Token token=#{ENV['ADMIN_API_KEY']}"
  end

  context 'valid' do
    post '/v1/services' do
      parameter :name, 'Name', scope: :service, required: true, type: :string
      parameter :curl_cmd, 'Curl Command. Use :key to connect with ' +
        'attributes of the review', scope: :service, required: true,
        type: :string
      parameter :execute_after, 'Specify the callback that you want to use to ' +
        'fire this curl command', scope: :service, required: true, type: :string

      let(:name) { 'Get a review' }

      let(:curl_cmd) do
        <<-EOF
          curl -g "localhost:3000/v1/reviews/:id" -X GET \
          -H "Accept: application/json" \
          -H "Content-Type: application/json" \
          -H "Authorization: Token token=qCwYhQXsr8rr792ZGIiCcgtt" \
          -H "Host: example.org" \
          -H "Cookie: "
        EOF
      end
      let(:execute_after) { 'creating' }

      let(:raw_post) { params.to_json }

      example_request 'create' do
        explanation 'Creates a new service '

        expect(status).to eq(201)

        service = JSON.parse(response_body, symbolize_names: true)

        expect(service[:name]).to eq(name)
        expect(service[:curl_cmd]).to eq(curl_cmd)
        expect(service[:curl_cmd]).to eq(curl_cmd)
        expect(service[:execute_after]).to eq(execute_after)
      end
    end
  end

  context 'invalid' do
    post '/v1/services' do
      parameter :name, 'Name', scope: :service, required: true, type: :string
      parameter :curl_cmd, 'Curl Command. Use :key to connect with ' +
        'attributes of the review', scope: :service, required: true,
        type: :string
      parameter :execute_after, 'Specify the callback that you want to use to ' +
        'fire this curl command', scope: :service, required: true, type: :string

      let(:name) { '' }

      let(:raw_post) { params.to_json }

      example_request 'create with empty values' do
        explanation 'Does not create a service with empty values '

        expect(status).to eq(422)

        errors = JSON.parse(response_body, symbolize_names: true)

        expect(errors[:name]).to include("can't be blank")
        expect(errors[:curl_cmd]).to include("can't be blank")
      end
    end
  end
end
