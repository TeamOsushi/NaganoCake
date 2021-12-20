# frozen_string_literal: true

class Customers::SessionsController < Devise::SessionsController
before_action :customer_state, only: [:create]

  def after_sign_in_path_for(resource)
    customers_path
  end
protected
# 退会しているかを判断するメソッドs
  def customer_state
  ## 【処理内容1】 入力されたemailからアカウントを1件取得
  @customer = Customer.find_by(email: params[:customer][:email])
    if @customer
      if @customer.valid_password?(params[:customer][:password]) && @customer.is_customer_status
        flash[:alert] = "このアカウントは退会済みです。"
        redirect_to new_customer_session_path
      end
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
