require 'rails_helper'

RSpec.describe "Api::V1::Tags", type: :request do
  describe "获取标签列表" do
    it "鉴权，仅可获取当前用户的标签" do
      user1 = User.create email: '1@qq.com'
      user2 = User.create email: '2@qq.com'
      11.times { Tag.create name: 'tag1', sign: '🐿️',user_id: user1.id }
      11.times { Tag.create name: 'tag1', sign: '🐿️',user_id: user2.id }
      # 鉴权
      get api_v1_tags_path
      expect(response).to have_http_status(401)
      # 获取当前用户的标签
      get api_v1_tags_path, headers: user1.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(11)
    end
  end
end
