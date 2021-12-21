class Public::AddressesController < ApplicationController

    def index
      	@addresses = current_customer.addresses
      	@address = Address.new
    end
    
    def create
    	  @address = Address.new(address_params)
    	  @address.customer_id = current_customer.id
        if @address.save
    	  	 flash.now[:notice] = "新規配送先を登録しました"
    	  	 redirect_to customers_addresses_path
        end
    end

	def edit
    @address = Address.find(params[:id])
	end

	def update
	  @address = Address.find(params[:id])
	  if @address.update(address_params)
  	 flash[:success] = "配送先を変更しました"
     redirect_to customers_addresses_path
	  else
	   render "edit"
	  end
	end

	def destroy
	  @address = Address.find(params[:id])
	  @address.destroy
    @addresses = current_customer.addresses
    flash.now[:alert] = "配送先を削除しました"
    redirect_to customers_addresses_path
	end

	private

    def address_params
      	params.require(:address).permit(:post_code, :address, :name)
    end

end
