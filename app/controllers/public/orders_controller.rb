class Public::OrdersController < ApplicationController
  include ApplicationHelper

  before_action :to_comfirmation, only: [:show]
  before_action :authenticate_customer!

  def new
  	@order = Order.new
  	@shipping_addresses = Address.where(customer: current_customer)
  end

	def confirm
    @cart_items = current_customer.cart_items
    @order = Order.new(order_params)
    @current_customer_order = current_customer
    #合計金額の計算式

        # addressにresidenceの値がはいっていれば
    if params[:order][:address_option] == "residence"
      @order.post_code = current_customer.post_code
      @order.address = current_customer.address
      @order.name = current_customer.last_name +
                           current_customer.first_name

    # addressにshipping_addressesの値がある場合
    elsif params[:order][:address_option] == "shipping_addresses"
      ship = Address.find(params[:order][:address_id])
      @order.post_code = ship.post_code
      @order.address = ship.address
      @order.name = ship.name

      # エラーメッセージを表示
      #unless @order.valid? == true
        #@shipping_addresses = ShippingAddress.where(customer: current_customer)
        #render :new
      #end
    end
    #合計金額の計算式
    sum = 0
    @cart_items.each do |cart_item|
      sum += cart_item.subtotal
    end
    @total_price = sum

    sum = 0
    @cart_items.each do |cart_item|
      sum += (cart_item.item.with_tax_price * cart_item.amount)
    end
    sum += @order.shipping_cost
    @order.total_payment = sum


	end

	def create
    @order = Order.new(order_params)
    @order.customer_id = current_customer.id
    @order.save

    flash[:notice] = "ご注文が確定しました。"
    redirect_to thanx_customers_orders_path

    # 新規住所(new_address)の場合saveする
    if params[:order][:addresses] == "2"
      current_customer.shipping_address.create(address_params)
    end

    # カートの情報を注文商品に移動
    @cart_items = current_customer.cart_items
    @cart_items.each do |cart_item|
    OrderItem.create(
      item_id: cart_item.item.id,
      order_id: @order.id,
      amount: cart_item.amount,
      price: cart_item.item.price_without_tax
    )
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
	  @order_items = @order.order_items
	end

  private

  def order_params
    params.require(:order).permit(:post_code, :address, :name, :payment_method, :total_payment, :order_items)
  end

  def address_params
    params.require(:address).permit(:post_code, :address, :name)
  end

  def to_comfirmation
    redirect_to customers_cart_items_path if params[:id] == "comfirmation"
  end
end