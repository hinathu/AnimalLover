class Admin::CustomersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @customers = Customer.all
  end

  def show
    @customer = Customer.find(params[:id])
    @items = Item.where(customer_id: @customer.id)
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def update
    @customer = Customer.find(params[:id])
      if @customer.update(customer_params)
        redirect_to admin_customer_path(@customer)
      else
        flash[:customer_updated_error] = "会員情報が正常に保存されませんでした。"
        render 'edit'
      end
  end


# 登録データのストロングパラメータ
  private

  def customer_params
    params.require(:customer).permit(:name, :profile_image, :email, :is_deleted)
  end
  
end
