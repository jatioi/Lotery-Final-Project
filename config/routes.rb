Rails.application.routes.draw do
  devise_for :users
  root 'welcome#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  resources :posts
  resources :admins, only: [] do
    collection do
      post :sign_in
      get :welcome
    end
  end
  namespace :admin do
    get 'welcome', to: 'home#index'
  end

end
