Gogopiao::Application.routes.draw do
  get "search_result/index"

  get "search/index"

  #resources :addresses

  resources :sellings

  resources :categories

  resources :regions

  resources :orders do
    get :success, :on => :member
  end

  resources :performers, only:[:index]

  match '/checkout' => 'orders#checkout'

  resources :events, only: [:index, :show] do
    resources :listings do
      get :calculate_net_price, on: :collection
      get :on_sale, on: :collection, action: "index_on_sale"
    end
  end

  resources :venues

  get '/api/v1/events' => 'api_events#index'

  resources :search_result

  root :to => "home#index"
  devise_for :users
  resources :users, only:[:show, :index]
end
