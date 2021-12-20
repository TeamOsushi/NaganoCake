class Public::CartItemsController < ApplicationController
  include ApplicationHelper

  before_action :cart_item, only: [:update, :destroy]
  before_action :authenticate_customer!

  def index
    @cart_items = current_customer.cart_items
  end

	def update
    @cart_item.update(amount: params[:cart_item][:amount].to_i)
    flash.now[:success] = "#{@cart_item.item.name}の数量を変更しました"
    @price = sub_price(@cart_item).to_s(:delimited)
    @cart_items = current_cart
    @total = total_price(@cart_items).to_s(:delimited)
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

	def all_destroy
    @cart_items = current_customer.cart_items
    @cart_items.destroy_all
    flash[:alert] = "カートの商品を全て削除しました"
    redirect_to customers_cart_items_path
	end

	def destroy
    @cart_item.destroy
    flash.now[:alert] = "#{@cart_item.item.name}を削除しました"
    @cart_items = current_cart
    @total = total_price(@cart_items).to_s(:delimited)
	end

  private

  def cart_item_params
    params.require(:cart_item).permit(:amount, :item_id)
  end
end