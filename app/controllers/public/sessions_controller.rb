# frozen_string_literal: true

class Public::SessionsController < Devise::SessionsController
  
  before_action :customer_state, only: [:create]
  before_action :delete_guest_user_item, only: [:destroy]

  def after_sign_in_path_for(resource)
    customer_path(current_customer.id)
  end

  def after_sign_out_path_for(resource)
    top_path
  end
  
  def guest_sign_in
    customer = Customer.guest
    sign_in customer
    redirect_to customer_path(current_customer.id), notice: "ゲストユーザーとしてログインしました。"
  end
  
  protected
  
  # ログアウトするときにゲストユーザーだった場合は、投稿・いいねしたitemを全て削除する
  def delete_guest_user_item
    if current_customer.email == 'guest@test'
      current_customer.items.destroy_all
      current_customer.favorites.destroy_all
      current_customer.comments.destroy_all
    end
  end
  
  # 退会しているかを判断するメソッド
  def customer_state
    ## 【処理内容1】 入力されたemailからアカウントを1件取得
    @customer = Customer.find_by(email: params[:customer][:email])
  
    ## アカウントを取得できなかった場合、このメソッドを終了する
    return if !@customer
  
    ## 【処理内容2】 取得したアカウントのパスワードと入力されたパスワードが一致してるかを判別かつ【処理内容3】 取得したアカウントのis_deletedカラムに格納されている値を確認
    if @customer.valid_password?(params[:customer][:password]) && @customer.is_deleted
      flash[:notice] = "退会済みです。再度ご登録をしてご利用ください。"
      redirect_to customer_session_path
    end
  end
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  # def create
  #   super
  # end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
