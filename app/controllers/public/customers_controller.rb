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
    if @customer.email == 'guest@test'
      flash[:customer_updated_error] = "ゲストユーザーは会員情報の編集ができません。"
    elsif @customer.update(customer_params)
        redirect_to customer_path(current_customer.id)
    else
        flash[:customer_updated_error] = "会員情報が正常に保存されませんでした。"
        render :edit
    end
  end

  # 退会機能
  def withdrawal
    @customer = Customer.find(params[:id])
    
    if @customer.email == 'guest@test'
      reset_session
      flash[:notice] = "ゲストユーザーは退会できません。"
      redirect_to top_path
    else
      # is_deletedカラムをtrueに変更することにより削除フラグを立てる
      @customer.update(is_deleted: true)
      reset_session
      flash[:notice] = "退会処理を実行いたしました。"
      redirect_to top_path
    end
  end
  
  # いいね一覧
  def favorites
    @customer = Customer.find(params[:id])
    favorites = Favorite.where(customer_id: @customer.id).pluck(:item_id)
    @favorite_items = Item.find(favorites)
  end
  
# 登録データのストロングパラメータ
  private

  def customer_params
    params.require(:customer).permit(:name, :profile_image, :email, :encrypted_password, :is_deleted)
  end
  
end