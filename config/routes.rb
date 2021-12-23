Rails.application.routes.draw do

  # admin
  devise_for :admins,skip: [:passwords,], controllers: {
    :sessions => 'admins/sessions',
    :registrations => 'admins/registrations',
   }
  namespace :admin do
    patch "orders/create_status" => "orders#create_status_update"
    resources :customers,only: [:index,:show,:edit,:update]
  	resources :items,only: [:index,:new,:create,:show,:edit,:update,]
  	resources :genres,only: [:index,:create,:edit,:update, :show]
  	resources :orders,only: [:index,:show,:update] do
  	get 'top'=>'public/homes#top'
  	post 'items' => 'items#create'
    get :current_index
    resources :order_items,only: [:update]
    get :order_index
    end
  end

   # customer
   devise_for :customers,skip: [:passwords,], controllers: {
    :sessions => 'customers/sessions',
    :registrations => 'customers/registrations',
   }
  root to: 'public/homes#top'
  root to: 'admin/homes#top'
  get 'public/home/about' => 'public/homes#about'
  
   scope module: :public do
    resources :items,only: [:index,:show]
    get 'search' => 'items#search'
    get 'customer/edit' => 'customers#edit'
    put 'customer' => 'customers#update'

  	resource :customers,only: [:show] do
  		collection do
  	     get 'unsubscribe'
  	     patch 'withdrawal'
  	  end

      resources :cart_items,only: [:index,:update,:create,:destroy] do
        collection do
          delete '/' => 'cart_items#all_destroy'
        end
      end

      resources :orders,only: [:new,:index,:show,:create] do
        collection do
          post 'confirm'
          get 'thanx'
        end
      end

      resources :addresses,only: [:index,:create,:edit,:update,:destroy]
    end
  end
end
