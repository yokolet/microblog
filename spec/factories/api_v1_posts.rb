FactoryBot.define do
  factory :api_v1_post, class: 'Api::V1::Post' do
    subject { "MyString" }
    content { "MyText" }
  end
end
