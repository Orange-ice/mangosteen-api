require 'rails_helper'

RSpec.describe "Session", type: :request do
  describe "会话" do
    it "登录（创建会话）" do
      User.create email: 'burthuang@foxmail.com'
      post api_v1_session_path, params: { email: 'burthuang@foxmail.com', code: '123456' }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['jwt']).to be_present
    end
  end
end
