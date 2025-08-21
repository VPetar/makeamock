require 'rails_helper'

RSpec.describe Api::DynamicController, type: :request do
  let(:user) { create(:user) }

  describe "GET /api/users?count=10" do
    before do
      create(:mock_model, name: "Users", user: user, fields: {
        "name"  => { type: "string", required: true },
        "email" => { type: "string", required: true }
      })
    end

    it "returns a list of users" do
      sign_in user, scope: :user
      get "/api/users", params: { count: 10 }, headers: { "Accept" => "application/json" }
      expect(response).to have_http_status(:ok)
      data = JSON.parse(response.body)["data"]
      expect(data).to be_an(Array)
      expect(data.size).to eq(10)
    end
  end

  describe "POST /api/users" do
    before do
      create(:mock_model, name: "Users", user: user, fields: {
        "name"  => { type: "string", required: true },
        "email" => { type: "string", required: true }
      })
    end

    it "mocks creation of a new user" do
      sign_in user, scope: :user
      post "/api/users", params: { name: "Test User", email: "qwe@qwe.qwe" }, headers: { "Accept" => "application/json" }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include("data")
      expect(JSON.parse(response.body)).to include("path")
      expect(JSON.parse(response.body)["data"]).to include("name" => "Test User", "email" => "qwe@qwe.qwe")
    end

    it "returns a 404 if the model is not found" do
      sign_in user, scope: :user
      post "/api/non_existent_model", params: { name: "Test User", email: "qwe@qwe.qwe" }, headers: { "Accept" => "application/json" }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PATCH /api/users/1" do
    before do
      create(:mock_model, name: "Users", user: user, fields: {
        "name"  => { type: "string", required: true },
        "email" => { type: "string", required: true }
      })
    end

    it "mocks updating an existing user" do
      sign_in user, scope: :user
      patch "/api/users/69", params: { name: "Updated User" }, headers: { "Accept" => "application/json" }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include("data")
      expect(JSON.parse(response.body)["data"]).to include("name" => "Updated User")
    end

    it "returns a 404 if the model is not found" do
      sign_in user, scope: :user
      patch "/api/non_existent_model/1", params: { name: "Updated User" }, headers: { "Accept" => "application/json" }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "PUT /api/users/69" do
    before do
      create(:mock_model, name: "Users", user: user, fields: {
        "name"  => { type: "string", required: true },
        "email" => { type: "string", required: true }
      })
    end

    it "mocks creating a new user with PUT" do
      sign_in user, scope: :user
      put "/api/users/69", params: { name: "New User", email: "qwe@qwe.qwe" }, headers: { "Accept" => "application/json" }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include("data")
      expect(JSON.parse(response.body)["data"]).to include("name" => "New User", "email" => "qwe@qwe.qwe", "id" => 69)
    end
  end

  describe "DELETE /api/users/1" do
    before do
      create(:mock_model, name: "Users", user: user, fields: {
        "name"  => { type: "string", required: true },
        "email" => { type: "string", required: true }
      })
    end

    it "mocks deletion of a user" do
      sign_in user, scope: :user
      delete "/api/users/1", headers: { "Accept" => "application/json" }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to eq({})
    end
  end

  describe "GET /api/dynamic/index/path" do
    it "returns a successful response" do
      sign_in user, scope: :user
      get "/api/dynamic/index/path", headers: { "Accept" => "application/json" }

      expect(response).to have_http_status(:ok)
      expect(response.content_type).to eq("application/json; charset=utf-8")
      expect(JSON.parse(response.body)).to eq({ "path" => "/dynamic/index/path", "data" => [] })
    end
  end
end
