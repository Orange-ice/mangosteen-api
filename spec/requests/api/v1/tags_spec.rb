require 'rails_helper'

RSpec.describe "Api::V1::Tags", type: :request do
  describe "获取标签列表" do
    it "鉴权，仅可获取当前用户的标签" do
      user1 = User.create email: '1@qq.com'
      user2 = User.create email: '2@qq.com'
      11.times do |i| Tag.create name: "tag#{i}", user_id: user1.id, sign: '🐿️' end
      11.times do |i| Tag.create name: "tag#{i}", user_id: user2.id, sign: '🐿️' end
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

  describe "创建标签" do
    it "鉴权，可创建标签" do
      user1 = User.create email: '2@qq.com'
      user2 = User.create email: '1@qq.com'
      # 鉴权
      post api_v1_tags_path, params: { name: 'tag1', sign: '🐿️' }
      expect(response).to have_http_status(401)
      # 创建标签
      post api_v1_tags_path, params: { name: 'tag1', sign: '🐿️' }, headers: user1.generate_auth_header
      expect(response).to have_http_status(201)
      json = JSON.parse(response.body)
      expect(json['resource']['name']).to eq('tag1')
      expect(json['resource']['sign']).to eq('🐿️')
      expect(json['resource']['user_id']).to eq(user1.id)
    end

    it "不可创建重复标签" do
      user1 = User.create email: '1@qq.com'
      Tag.create name: 'tag1', sign: '🐿️',user_id: user1.id
      # 创建重复标签
      post api_v1_tags_path, params: { name: 'tag1', sign: '🐿️' }, headers: user1.generate_auth_header
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json['errors'][0]).to eq('Name has already been taken')
    end

    it "不可创建空标签，且符号不可为空" do
      user1 = User.create email: '1@qq.com'
      # 创建空标签
      post api_v1_tags_path, params: { name: '', sign: '🐿️' }, headers: user1.generate_auth_header
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json['errors'][0]).to eq("Name can't be blank")
      # 创建空符号
      post api_v1_tags_path, params: { name: 'tag1', sign: '' }, headers: user1.generate_auth_header
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json['errors'][0]).to eq("Sign can't be blank")
    end

    it "不可创建超过32个字符的标签" do
      user1 = User.create email: '1@qq.com'
      post api_v1_tags_path, params: { name: 'tag1' * 32, sign: '🐿️' }, headers: user1.generate_auth_header
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json['errors'][0]).to eq("Name is too long (maximum is 32 characters)")
    end

    it "不可创建超过32个字符的符号" do
      user1 = User.create email: '1@qq.com'
      post api_v1_tags_path, params: { name: 'tag1', sign: '🐿️' * 32 }, headers: user1.generate_auth_header
      expect(response).to have_http_status(422)
      json = JSON.parse(response.body)
      expect(json['errors'][0]).to eq("Sign is too long (maximum is 32 characters)")
    end

  end
end
