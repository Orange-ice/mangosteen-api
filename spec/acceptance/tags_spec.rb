require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "标签" do
  authentication :basic, :auth
  let(:current_user) { User.create email: '1@qq.com' }
  let(:auth) { "Bearer #{current_user.generate_jwt}" }
  get "/api/v1/tags/:id" do
    let (:tag) { Tag.create name: 'tag name', sign:'🐿️', user_id: current_user.id }
    let (:id) { tag.id }
    with_options :scope => :resource do
      response_field :id, 'ID'
      response_field :name, "名称"
      response_field :sign, "符号"
    end
    example "获取标签" do
      do_request
      expect(status).to eq 200
      json = JSON.parse response_body
      expect(json['resource']['id']).to eq tag.id
    end
  end
  get "/api/v1/tags" do
    with_options :scope => :resources do
      response_field :id, 'ID'
      response_field :name, "名称"
      response_field :sign, "符号"
    end
    example "获取标签列表" do
      11.times do |index| Tag.create name: "tag#{index}", sign:'🐿️', user_id: current_user.id end
      do_request
      expect(status).to eq 200
      json = JSON.parse response_body
      expect(json['resources'].size).to eq 11
    end
  end
  post "/api/v1/tags" do
    parameter :name, '名称', required: true
    parameter :sign, '符号', required: true
    with_options :scope => :resource do
      response_field :id, 'ID'
      response_field :name, "名称"
      response_field :sign, "符号"
    end
    let (:name) { 'tag name' }
    let (:sign) { '🐿️' }
    example "创建标签" do
      do_request
      expect(status).to eq 201
      json = JSON.parse response_body
      expect(json['resource']['name']).to eq name
      expect(json['resource']['sign']).to eq sign
    end
  end
  patch "/api/v1/tags/:id" do
    let (:tag) { Tag.create name: 'tag name', sign:'🐿️', user_id: current_user.id }
    let (:id) { tag.id }
    parameter :name, '名称'
    parameter :sign, '符号'
    with_options :scope => :resource do
      response_field :id, 'ID'
      response_field :name, "名称"
      response_field :sign, "符号"
    end
    let (:name) { 'tag name new' }
    let (:sign) { '🥰' }
    example "修改标签" do
      do_request
      expect(status).to eq 200
      json = JSON.parse response_body
      expect(json['resource']['name']).to eq name
      expect(json['resource']['sign']).to eq sign
    end
  end
  delete "/api/v1/tags/:id" do
    let (:tag) { Tag.create name: 'tag name', sign:'🥰', user_id: current_user.id }
    let (:id) { tag.id }
    example "删除标签" do
      do_request
      expect(status).to eq 200
    end
  end
end