Rails.application.routes.draw do
  constraints(AdminDomainConstraint.new) do
    root "admin/home#index", as: :admin_root

    devise_for :users, as: :admin, path: '', controllers: {
      sessions: 'admin/users/sessions',
    }

    namespace :admin do
      resources :items
      resources :items, except: :show do
        member do
          post 'start'
          post 'pause'
          post 'end'
          post 'cancel'
        end
      end
    end

  end

  constraints(ClientDomainConstraint.new) do
    root "client/home#index", as: :client_root
    resources :client do
    end

    devise_for :users, as: :client, controllers: {
      sessions: 'client/users/sessions',
      registrations: 'client/users/registrations'
    }

    get "/me", to: 'client/me#index'
    get "/invite", to: 'client/invite#index'

    resources 'client/address', as: 'address', path: 'address', except: [:show, :edit]

  end


  namespace :api do
    namespace :v1 do
      resources :regions, only: [:index, :show], defaults: { format: :json } do
        resources :provinces, only: :index, defaults: { format: :json }
      end

      resources :provinces, only: [:index, :show], defaults: { format: :json } do
        resources :cities, only: :index, defaults: { format: :json }
      end

      resources :cities, only: [:index, :show], defaults: { format: :json } do
        resources :barangays, only: :index, defaults: { format: :json }
      end

      resources :barangays, only: [:index, :show], defaults: { format: :json }
    end
  end

end


