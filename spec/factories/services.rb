FactoryBot.define do
  factory :service do
    name { "MyString" }
    curl_cmd { "MyText" }
    execute_after { 1 }
  end
end
