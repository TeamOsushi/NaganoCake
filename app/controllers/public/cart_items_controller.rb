class Public::CartItemsController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_customer!

  def index
    @cart_items = current_customer.cart_items
    
    sum = 0
    @cart_items.each do |cart_item|
      sum += cart_item.subtotal
    end
    @total_price = sum
  end



	def create
    @cart_item = CartItem.new(cart_item_params)
    @cart_item.customer_id = current_customer.id

    # 追加した商品の数量を合わせる
    @update_cart_item =  CartItem.find_by(item: @cart_item.item)
    if @update_cart_item.present? && @cart_item.valid?
        @cart_item.amount += @update_cart_item.amount
        @update_cart_item.destroy
    end

    if @cart_item.save
      flash[:notice] = "#{@cart_item.item.item_name}をカートに追加しました"
      redirect_to customers_cart_items_path
    else
      @item = Item.find(params[:cart_item][:item_id])
      @cart_item = CartItem.new
      flash[:alert] = "個数を選択してください"
      render "public/items/show"
    end
	end
	
	def update
	  cart_item = CartItem.find(params[:id])
    cart_item.update(cart_item_params)
     flash.now[:success] = "#{cart_item.item.item_name}の数量を変更しました"
    redirect_to customers_cart_items_path
	end

	def all_destroy
    @cart_items = current_customer.cart_items
    @cart_items.destroy_all
    flash[:alert] = "カートの商品を全て削除しました"
    redirect_to customers_cart_items_path
	end

  def destroy
    @cart_item = CartItem.find(params[:id])
    @cart_item.destroy
    flash[:alert] = "カートから削除しました"
    redirect_to customers_cart_items_path
  end
	
  private

  def cart_item_params
    params.require(:cart_item).permit(:amount, :item_id)
  end
end