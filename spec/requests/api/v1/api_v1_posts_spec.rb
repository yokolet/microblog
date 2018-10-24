require 'rails_helper'

RSpec.describe "Api::V1::Posts", type: :request do
  let!(:posts) { create_list(:api_v1_post, 10)}

  describe "GET /api_v1_posts" do
    before { get api_v1_posts_path }
    it "returns status code 200" do
      expect(response).to have_http_status(200)
    end

    it "returns posts" do
      json = JSON.parse(response.body)
      expect(json).not_to be_empty
      expect(json.size).to eq(10)
    end
  end
end
