require 'rails_helper'
require 'rspec_api_documentation'
require 'rspec_api_documentation/dsl'

RspecApiDocumentation.configure do |config|
  config.format = %i[JSON combined_text html]
  config.curl_host = 'https://stark-mesa-90873.herokuapp.com'
  config.api_name = 'Customer Reviews'
  config.api_explanation = 'This API allows you to manage customer reviews ' +
                           'inside different stores and orders'
end
