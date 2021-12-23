class Admin::OrderItemsController < ApplicationController
    
def update
	@order_item = OrderItem.find(params[:order_id])
	@order = @order_item.order
    @create_status = params[:order_item][:create_status].to_i
    if @order_item.update(order_item_params)
    redirect_to admin_order_path(@order)
    else
    render "show"
    end
end

	private
	def order_item_params
	    params.require(:order_item).permit(:create_status, :id, :order_id)
	end
	
end
