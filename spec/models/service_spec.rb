require 'rails_helper'

RSpec.describe Service, type: :model do
  describe 'columns' do
    it { is_expected.to have_db_column(:name).of_type(:string) }
    it { is_expected.to have_db_column(:curl_cmd).of_type(:text) }
    it do
      is_expected.to have_db_column(:execute_after).of_type(:integer).
        with_options(default: 'creating')
    end
    it do
      is_expected.to define_enum_for(:execute_after).
        with([:creating, :updating, :destroying, :crud])
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:curl_cmd) }
    it { is_expected.to validate_presence_of(:execute_after) }
  end
end
