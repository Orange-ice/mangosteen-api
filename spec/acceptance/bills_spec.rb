require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "账单" do
  get "/api/v1/bills" do
    # 身份认证
    authentication :basic, :auth
    # 请求参数
    parameter :page, "页码"
    parameter :per_page, "每页数量"
    parameter :start_date, "开始日期（筛选条件）"
    parameter :end_date, "结束日期（筛选条件）"

    # 响应参数
    with_options scope: :resources do
      response_field :id, "账单ID"
      response_field :amount, "金额"
      response_field :tag_id, "标签ID"
      response_field :created_at, "创建时间"
    end

    let (:page) { 1 }
    let (:per_page) { 10 }
    let (:start_date) { '2020-01-01' }
    let (:end_date) { '2020-01-06' }
    let (:current_user) { User.create email: '1@qq.com' }
    let(:auth) { "Bearer #{current_user.generate_jwt}" }
    example "获取账单" do
      11.times { Bill.create amount: 100, user_id: current_user.id, tag_id: 1, created_at: '2020-01-03' }
      do_request
      expect(status).to eq(200)
      json = JSON.parse(response_body)
      expect(json['resources'].size).to eq(10)
    end
  end
end