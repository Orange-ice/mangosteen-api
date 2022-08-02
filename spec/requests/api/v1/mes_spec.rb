require 'rails_helper'

RSpec.describe "Api::V1::Mes", type: :request do
  describe "当前用户" do
    it "获取当前用户" do
      user = User.create email: '2902978956@qq.com'
      post api_v1_session_path, params: { email: user.email, code: '123456' }
      jwt = JSON.parse(response.body)['jwt']

      get api_v1_me_path, headers: { Authorization: "Bearer #{jwt}" }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resource']['id']).to eq(user.id)
    end
  end
end
