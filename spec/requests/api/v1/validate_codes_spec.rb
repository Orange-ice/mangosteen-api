require 'rails_helper'

RSpec.describe "Api::V1::ValidateCodes", type: :request do
  describe "验证码" do
    it "发送太频繁会返回 429" do
      post api_v1_validate_codes_path, params: {email: "2902978956@qq.com"}
      expect(response).to have_http_status(:created)
      post api_v1_validate_codes_path, params: {email: "2902978956@qq.com"}
      expect(response).to have_http_status(:too_many_requests)
    end
  end
end
