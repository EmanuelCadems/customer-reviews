require 'vcr'
VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  # c.default_cassette_options = {
  #   :match_requests_on => [:method, :host, :path]
  # }
  c.configure_rspec_metadata!
  c.ignore_localhost = false
  c.allow_http_connections_when_no_cassette = false

  c.filter_sensitive_data('api_key') { ENV['API_KEY'] }
end
