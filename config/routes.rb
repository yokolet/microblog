Rails.application.routes.draw do
  root to: 'home#index'
  namespace :api do
    namespace :v1 do
      resources :posts
    end
  end
  match '*path', to: 'all_other#index', via: :all
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
