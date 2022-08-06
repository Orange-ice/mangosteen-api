require 'rails_helper'
require 'active_support/testing/time_helpers'

RSpec.describe "Api::V1::Mes", type: :request do
  include ActiveSupport::Testing::TimeHelpers

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

    it "jwt 过期验证" do
      user = User.create email: '1@qq.com'
      header = user.generate_auth_header

      # 1小时后，jwt未过期
      travel_to 1.hour.from_now do
        get api_v1_me_path, headers: header
        expect(response).to have_http_status(200)
      end

      # 3小时后，jwt已过期
      travel_to 3.hours.from_now do
        get api_v1_me_path, headers: header
        expect(response).to have_http_status(401)
      end
    end
  end
end
