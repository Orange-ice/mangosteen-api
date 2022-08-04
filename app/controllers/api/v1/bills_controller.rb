class Api::V1::BillsController < ApplicationController
  def index
    bills = Bill.page(params[:page]).per(params[:per_page])
    render status: :ok, json: { resources: bills, pager: {
      page: params[:page] || 1,
      per_page: params[:per_page] || Item.default_per_page,
      count: Bill.count
    } }
  end
end
