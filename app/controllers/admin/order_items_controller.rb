class Admin::OrderItemsController < ApplicationController
    
def update
	@order_item = OrderItem.find(params[:order_id])
	@order = @order_item.order
	order_items = OrderItem.where(order_id: @order.id)
    @create_status = params[:order_item][:create_status].to_i
    if @order_item.update(order_item_params)
        #製作ステータスが製作中になると注文ステータスも製作中になる
		if @order_item.create_status == "in_production"
			@order.order_status = "in_production"
			@order.save
		end
		#製作ステータスが全て製作完了になると注文ステータスが発送準備中になる
        if @order_item.create_status == "production_completed"
          compiled_items = order_items.select do |order_item|
             order_item.create_status == "production_completed"
            end
            if compiled_items.size == order_items.size
                @order.order_status = "preparing_ship"
　　　　　　　o-da-	@order.save
		    end
         end
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
