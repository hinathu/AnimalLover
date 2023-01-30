class Public::CustomersController < ApplicationController
  
  before_action :authenticate_customer!

  def show
    @customer = Customer.find(params[:id])
    @items = Item.where(customer_id: @customer.id)
  end

  def edit
    @customer = current_customer
  end

  def update
    @customer = current_customer
    if @customer.update(customer_params)
        redirect_to customer_path(current_customer.id)
    else
        flash[:customer_updated_error] = "会員情報が正常に保存されませんでした。"
        render :edit
    end
  end

  def withdrawal
    @customer = current_customer
    # is_deletedカラムをtrueに変更することにより削除フラグを立てる
    @customer.update(is_deleted: true)
    reset_session
    redirect_to top_path
  end

# 登録データのストロングパラメータ
  private

  def customer_params
    params.require(:customer).permit(:name, :profile_image, :email, :encrypted_password, :is_deleted)
  end
  
end