Rails.application.routes.draw do
  constraints(AdminDomainConstraint.new) do
    root "admin/home#index", as: :admin_root

    devise_for :users, as: :admin, path: '', controllers: {
      sessions: 'admin/users/sessions',
    }

  end

  constraints(ClientDomainConstraint.new) do
    root "client/home#index", as: :client_root
    resources :client do
    end

    devise_for :users, as: :client, path: '', controllers: {
      sessions: 'client/users/sessions',
      registrations: 'client/users/registrations'
    }

    get "/me", to: 'client/me#index'

    resources 'client/address', as: 'address', path: 'address', except: :show
  end
end


