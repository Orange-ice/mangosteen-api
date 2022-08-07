class Api::V1::BillsController < ApplicationController
  def index
    user_id = request.env['current_user_id']
    return render status: :unauthorized unless user_id
    bills = Bill.where(user_id: user_id, happened_at: params[:start_date]..params[:end_date])
      .page(params[:page]).per(params[:per_page])
    
    render status: :ok, json: { resources: bills, pager: {
      page: params[:page] || 1,
      per_page: params[:per_page] || Bill.default_per_page,
      count: bills.total_count
    } }
  end

  def create
    user_id = request.env['current_user_id']
    bill = Bill.new amount: params[:amount], tag_id: params[:tag_id], user_id: user_id, happened_at: params[:happened_at]
    return render json: { errors: bill.errors }, status: :unprocessable_entity unless bill.save
    render status: :created, json: { resource: bill }
  end

  def summary
    bills = Bill
      .where(user_id: request.env['current_user_id'])
      .where(kind: params[:kind])
      .where(happened_at: params[:start_date]..params[:end_date])
      .group(:happened_at)
      .sum(:amount)
    groups = bills.map { |key, value| { happened_at: key, amount: value } }
    render status: :ok, json: { resources: groups, total: bills.values.sum }
  end
end
