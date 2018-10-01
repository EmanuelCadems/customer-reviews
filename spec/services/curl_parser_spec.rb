require 'spec_helper'

RSpec.describe CurlParser do
  # Time.now.iso8601(3)
  let(:api_reference_create_before_create) do
    <<-EOF
      curl --header "Content-Type: application/json" \
         --request POST \
         --data '{
            "store_id": ":store_id",
            "order_id": ":order_id",
            "user_id": ":user_id",
            "opinion": ":opinion",
            "score": ":score",
            "created_at": ":created_at",
            "updated_at": ":updated_at"
          }' \
         https://api.jsonbin.io/b
    EOF
  end

  let(:api_reference_create_after_create) do
    <<-EOF
      curl --header "Content-Type: application/json" \
         --request POST \
         --data '{
            "store_id": "#{review.store_id}",
            "order_id": "#{review.order_id}",
            "user_id": "#{review.user_id}",
            "opinion": "#{review.opinion}",
            "score": "#{review.score}",
            "created_at": "#{review.created_at.iso8601(3)}",
            "updated_at": "#{review.updated_at.iso8601(3)}"
          }' \
         https://api.jsonbin.io/b
    EOF
  end

  let(:woeid) { 2460286 }
  let(:review) { create(:review, store_id: woeid, opinion: 'dev') }

  let(:weather_api_before_crud) do
    <<-EOF
      curl https://query.yahooapis.com/v1/public/yql \
       -d q="select wind from weather.forecast where woeid=:store_id" \
       -d format=json
    EOF
  end

  let(:weather_api_after_crud) do
    <<-EOF
      curl https://query.yahooapis.com/v1/public/yql \
       -d q="select wind from weather.forecast where woeid=2460286" \
       -d format=json
    EOF
  end

  context 'with services' do
    before do
      create(
        :service,
        name: 'https://developer.yahoo.com/weather',
        curl_cmd: weather_api_before_crud,
        execute_after: 'crud'
      )
    end
    context "execute_after='creating'" do
      subject { CurlParser.new(review.attributes, 'creating') }

      before do
        create(
          :service,
          name: 'https://jsonbin.io/api-reference/bins/create',
          curl_cmd: api_reference_create_before_create,
          execute_after: 'creating'
        )
      end

      it 'includes the curl cmds to execute_after creation with the right ' +
         'values' do
        expect(subject.exec).to include(api_reference_create_after_create)
      end

      it 'includes the curl cmds to execute_after crud with the right values' do
        expect(subject.exec).to include(weather_api_after_crud)
      end
    end

    context "execute_after='updating'" do
      let(:recipe_puppy_api_before_update) do
        'curl http://www.recipepuppy.com/api/?i=onions,garlic&q=omelet&p=:store_id'
      end

      let(:recipe_puppy_api_after_update) do
        'curl http://www.recipepuppy.com/api/?i=onions,garlic&q=omelet&p=2460286'
      end

      subject { CurlParser.new(review.attributes, 'updating') }

      before do
        create(
          :service,
          name: 'http://www.recipepuppy.com/about/api/',
          curl_cmd: recipe_puppy_api_before_update,
          execute_after: 'updating'
        )
      end

      it 'includes the curl cmds to execute_after updating with the right ' +
         'values' do
        expect(subject.exec).to include(recipe_puppy_api_after_update)
      end

      it 'includes the curl cmds to execute_after crud with the right values' do
        expect(subject.exec).to include(weather_api_after_crud)
      end
    end

    context "execute_after='destroying'" do
      let(:api_chucknorris_before_destroy) do
        'curl https://api.chucknorris.io/jokes/random?category={":opinion"}'
      end

      let(:api_chucknorris_after_destroy) do
        'curl https://api.chucknorris.io/jokes/random?category={"dev"}'
      end

      subject { CurlParser.new(review.attributes, 'destroying') }

      before do
        create(
          :service,
          name: 'http://www.recipepuppy.com/about/api/',
          curl_cmd: api_chucknorris_before_destroy,
          execute_after: 'destroying'
        )
      end

      it 'includes the curl cmds to execute_after destroying with the right ' +
         'values' do
        expect(subject.exec).to include(api_chucknorris_after_destroy)
      end

      it 'includes the curl cmds to execute_after crud with the right values' do
        expect(subject.exec).to include(weather_api_after_crud)
      end
    end

  end

  context 'without services' do
    subject { CurlParser.new(review.attributes, 'creating') }

    it 'returns an empty array' do
      expect(subject.exec).to be_empty
    end
  end
end
