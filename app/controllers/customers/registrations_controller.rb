# frozen_string_literal: true

class Customers::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters, only: [:create]
  before_action :authenticate_customer!, only: [:edit, :update]
  # before_action :configure_account_update_params, only: [:update]
  
  def after_sign_in_path_for(resource)
    root_path
  end
  
  def after_sign_up_path_for(resource)
    root_path
  end
  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  def edit
    @customer = current_customer
  end

  # PUT /resource
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?
      # respond_with resource, location: after_update_path_for(resource)
      flash[:success] = "パスワード変更しました。"
      redirect_to customers_path
    else
      clean_up_passwords resource
      set_minimum_password_length
      redirect_to customers_path
      flash[:alert] = "パスワードを変更できませんでした。"
    end
    # super
  end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def customer_params
    params.require(:customers).permit(:password, :password_confirmation)
  end
  # If you have extra params to permit, append them to the sanitizer.
  #def configure_sign_up_params
  # devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  #end
  # 新規登録の保存機能
    def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up,
  			 keys: [:first_name, :last_name, :kana_first_name, :kana_last_name,
                :email, :post_code, :address, :telephone_number])

    end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:password, :password_confirmation])
  # end

  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  def update_resource(resource, params)
    resource.update_with_password(params)
  end

  def after_update_path_for(resource)
    customers_path(resource)
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end