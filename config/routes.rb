AppLairoflithCom::Application.routes.draw do
  devise_for :users

  get "home/index"
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'

  get 'characters', to: 'characters#index', as: 'characters'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'
  get 'users/:id', to: 'users#view', as: 'user'

  get 'tags', to: 'tags#index', as: 'all_tags'
  get 'tags/:tag', to: 'tags#view', as: 'tag'

  get 'characters/new', to: 'characters#new', as: 'character_new'
  get 'users/:uid/characters/:cid', to: 'characters#view', as: 'character'
  get 'users/:uid/characters/:cid/:version/generate' => 'characters#generate', as: 'character_generate'
  post 'characters/save', to: 'characters#save', as: 'character_save'
  patch 'users/:uid/characters/:cid/save_data', to: 'characters#save_data', as: 'character_save_data'
  delete 'characters/destroy' => 'characters#destroy'

  get 'characters/help', to: 'characters#help', as: 'character_help'
  get 'characters/walkthrough', to: 'characters#walkthrough', as: 'character_walkthrough'
  get 'characters/guide', to: 'characters#guide', as: 'character_guide'

  get 'contact' => 'contact#new'
  post 'contact' => 'contact#create'

  post 'bbcode' => 'home#bbcode'

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
