require 'simplecov'

if ENV['RAILS_ENV'] == 'test'
  require 'simplecov'
  SimpleCov.start 'rails' do
    add_filter 'app/mailers/application_mailer.rb'
    add_filter 'app/channels/application_cable/connection.rb'
    add_filter 'app/channels/application_cable/channel.rb'
    add_filter 'app/models/application_record.rb'

    add_group 'Services', ['app/services']
  end
end
