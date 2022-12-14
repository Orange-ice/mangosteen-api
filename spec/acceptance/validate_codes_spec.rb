require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "验证码" do
  post "/api/v1/validate_codes" do
    parameter :email, "邮箱", required: true, type: :string
    let(:email) { "123@example.com" }
    example "发送验证码" do
      # 期待 UserMailer 的 welcome_mail 方法被调用
      expect(UserMailer).to receive(:welcome_email).with(email)

      do_request
      expect(status).to eq 201
      expect(response_body).to eq ' '
    end
  end
end