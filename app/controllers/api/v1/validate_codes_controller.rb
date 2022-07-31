class Api::V1::ValidateCodesController < ApplicationController
  def create
    code = SecureRandom.random_number.to_s[2..7]
    validate_code = ValidateCode.new code: code, email: params[:email]
    if validate_code.save
      UserMailer.welcome_email(code, params[:email]).deliver_later
      render status: :created
    else
      render json: { errors: validate_code.errors.full_messages }, status: :unprocessable_entity
    end
  end
end
