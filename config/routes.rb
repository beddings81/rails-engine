Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "/merchants/find", to: 'merchants_search#show'
      resources :items do
        resources :merchant, only: [:index]
      end

      resources :merchants, only: [:index, :show] do
        resources :items, only: [:index]
      end
    end
  end

end
