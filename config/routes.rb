Rails.application.routes.draw do
#  get 'users/show'

  get 'relationships/create'

  get 'relationships/destroy'

#  get 'users/index'    コントローラー作成時に生成された無用なルーティングなので削除したよ。dive16

#  get 'comments/create'  コントローラー作成時に生成された無用なルーティングなので削除したよ。dive15

  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'

  # deviseにomniauthを追加したよ。dive14
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks"
  }

#  get 'top/index'    # root設定しているので、コントローラー作成時に生成された無用なルーティングは削除します
  get 'contacts' => 'contacts#new'  #dive01課題で追記したよ。
  resources :contacts, only: [:new, :create] do #dive01課題で追記したよ。
    collection do    # dive03課題で追記したよ。
      post :confirm
    end
  end

  # dive01で追記したよ。
  get 'blogs' => 'blogs#index'
  # dive15でonlyを削除したよ。only: [:index, :new, :create, :edit, :update, :destroy]
  # dive15でcommentsを追記したよ。
  resources :blogs do
    resources :comments
    
    collection do
      post :confirm
    end
  end
                                # dive01で追記したよ。
                                # dive02でedit,update,destroyを追加したよ。
                                # dive03でresources do,collection doと追記したよ。

  root 'top#index'    # dive04で追記したよ。

# dive16で追記したよ。
  resources :users, only: [:index, :show]
  resources :relationships, only: [:create, :destroy]


  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
