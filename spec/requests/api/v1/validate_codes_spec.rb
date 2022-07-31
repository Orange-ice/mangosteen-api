require 'rails_helper'

RSpec.describe "Api::V1::ValidateCodes", type: :request do
  describe "验证码" do
    it "正常发送" do
      post api_v1_validate_codes_path, params: {email: "2902978956@qq.com"}
      expect(response).to have_http_status(:created)
    end
  end
end
