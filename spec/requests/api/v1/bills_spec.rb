require 'rails_helper'

RSpec.describe "Api::V1::Bills", type: :request do
  describe "获取账单" do
    it "支持分页" do
      # 创建11个账单
      11.times { Bill.create amount: 100, user_id: 1, tag_id: 1 }
      # 获取第一页
      get api_v1_bills_path, params: { page: 1, per_page: 10 }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(10)
      # 获取第二页
      get api_v1_bills_path, params: { page: 2, per_page: 10 }
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(1)
    end
  end
end
