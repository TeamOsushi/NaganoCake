class Public::OrdersController < ApplicationController
  include ApplicationHelper

  before_action :to_comfirmation, only: [:show]
  before_action :authenticate_customer!
  
  def new
  	@order = Order.new
  	@shipping_addresses = Address.where(customer: current_customer)
  end

	def log
    @cart_items = current_customer.cart_items
		@order = Order.new(
      customer: current_customer,
      payment_method: params[:order][:payment_method]
    )


    # addressにresidenceの値がはいっていれば
    if params[:order][:addresses] == "residence"
      @order.post_code = current_customer.post_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name +
                           current_customer.first_name

    # addressにshipping_addressesの値がある場合
    elsif params[:order][:addresses] == "shipping_addresses"
      ship = ShippingAddress.find(params[:order][:shipping_address_id])
      @order.post_code = ship.post_code
      @order.address = ship.address
      @order.name = ship.name

    # addressにnew_addressの値がある場合
    elsif params[:order][:addresses] == "new_address"
      @order.post_code = params[:order][:post_code]
      @order.address = params[:order][:address]
      @order.name = params[:order][:name]
      @ship = "1"

      # エラーメッセージを表示
      unless @order.valid? == true
        @shipping_addresses = ShippingAddress.where(customer: current_customer)
        render :new
      end
    end
    #合計金額の計算式
    sum = 0
    @cart_items.each do |cart_item|
      sum += (cart_item.item.price_without_tax * cart_item.amount)
    end
    sum += @order.shipping_cost
    @order.total_payment = sum
	end

	def create
    @order = current_customer.orders.new(order_params)
    @order.save
    flash[:notice] = "ご注文が確定しました。"
    redirect_to thanx_customers_orders_path

    # 新規住所(new_address)の場合saveする
    if params[:order][:ship] == "1"
      current_customer.shipping_address.create(address_params)
    end

    # カートの情報を注文商品に移動
    @cart_items = current_customer.cart_items
    @cart_items.each do |cart_item|
    #Orders.create(
      #item: cart_item.item,
      #order: @order,
      #amount: cart_item.amount,
      #subprice: sub_price(cart_item)
    #)
    end
    # 注文完了後、カートを空にする
    @cart_items.destroy_all
	end

	def thx
	end

	def index
    @orders = current_customer.orders
    if @oder.nil?
        @nil_result = "nil"
    else
        @nil_result = "nil"
    end
	end

	def show
	  @order = Order.find(params[:id])
    @create_status = @order.create_status
	end

  private

  def order_params
    params.require(:order).permit(:post_code, :address, :name, :payment_method, :total_payment)
  end

  def address_params
    params.require(:address).permit(:post_code, :address, :name)
  end

  def to_log
    redirect_to customers_cart_items_path if params[:id] == "comfirmation"
  end
end
