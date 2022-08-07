require 'rails_helper'

RSpec.describe "Api::V1::Bills", type: :request do
  describe "获取账单" do
    it "鉴权，仅可查询当前用户的账单" do
      user1 = User.create email: '1@qq.com'
      user2 = User.create email: '2@qq.com'
      tag1 = Tag.create name: 'tag1', user_id: user1.id, sign: '🍲'
      tag2 = Tag.create name: 'tag2', user_id: user2.id, sign: '🍲'
      11.times { Bill.create amount: 100, user_id: user1.id, tag_id: tag1.id, happened_at: Time.now }
      11.times { Bill.create amount: 100, user_id: user2.id, tag_id: tag2.id, happened_at: Time.now }
      # 鉴权
      get api_v1_bills_path
      expect(response).to have_http_status(401)
      # 获取当前用户的账单
      get api_v1_bills_path, headers: user1.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(11)
    end

    it "支持分页" do
      user = User.create email: '1@qq.com'
      tag = Tag.create name: 'tag1', user_id: user.id, sign: '🍲'
      # 创建11个账单
      11.times { Bill.create amount: 100, user_id: user.id, tag_id: tag.id, happened_at: Time.now }
      # 获取第一页
      get api_v1_bills_path, params: { page: 1, per_page: 10 }, headers: user.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(10)
      # 获取第二页
      get api_v1_bills_path, params: { page: 2, per_page: 10 }, headers: user.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(1)
    end

    it "可按时间筛选" do
      user = User.create email: '1@qq.com'
      tag = Tag.create name: 'tag1', user_id: user.id, sign: '🍲'
      bill1 = Bill.create amount: 100, user_id: user.id, tag_id: tag.id, created_at: '2020-01-01', happened_at: '2020-01-01'
      bill2 = Bill.create amount: 100, user_id: user.id, tag_id: tag.id, created_at: '2020-01-05', happened_at: '2020-01-05'
      bill3 = Bill.create amount: 100, user_id: user.id, tag_id: tag.id, created_at: '2020-01-09', happened_at: '2020-01-09'
      get api_v1_bills_path, params: { start_date: '2020-01-01', end_date: '2020-01-06' }, headers: user.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(2)
      expect(json['resources'][0]['id']).to eq(bill1.id)
      expect(json['resources'][1]['id']).to eq(bill2.id)

      # 边界条件
      get api_v1_bills_path, params: { start_date: '2020-01-01', end_date: '2020-01-01' }, headers: user.generate_auth_header
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['resources'].size).to eq(1)
      expect(json['resources'][0]['id']).to eq(bill1.id)
    end
  end

  describe "创建账单" do
    it "鉴权，可创建账单" do
      user = User.create email: '1@qq.com'
      tag = Tag.create name: '餐饮', user_id: user.id, sign: '🍲'
      # 鉴权
      post api_v1_bills_path, params: { amount: 100, tag_id: 1, happened_at: Time.now }
      expect(response).to have_http_status(401)
      # 创建账单
      post api_v1_bills_path, params: { amount: 100, tag_id: tag.id, happened_at: Time.now }, headers: user.generate_auth_header
      expect(response).to have_http_status(201)
      json = JSON.parse(response.body)
      expect(json['resource']['id']).to be_present
    end

    it "创建账单时，只能选择自己创建的标签" do
      user = User.create email: '1@qq.com'
      post api_v1_bills_path, params: { amount: 100, tag_id: 1, happened_at: Time.now }, headers: user.generate_auth_header
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json['errors']).to eq('tag_id' => ['tag_id is invalid'])
    end

    it "创建账单时，amount, tag_id, happened_at 都必填" do
      user = User.create email: '1@qq.com'
      post api_v1_bills_path, params: {}, headers: user.generate_auth_header
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json['errors']).to eq('amount' => ['can\'t be blank'], 'tag_id' => ['can\'t be blank'], 'happened_at' => ['can\'t be blank'])
    end
  end
end
