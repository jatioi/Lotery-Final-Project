Rails.application.routes.draw do
  devise_for :users
  # resources :admins, only: [] do
  #   collection do
  #     post :sign_in
  #     get :welcome
  #   end
  # end
  constraints(AdminDomainConstraint.new) do
    root "admin/home#index", as: :admin_root

    devise_for :users, as: :admin, path: '', controllers: {
      sessions: 'admin/users/sessions',
      registrations: 'admin/users/registrations'
    }

  end

  constraints(ClientDomainConstraint.new) do
    root "client/home#index", as: :client_root
    resources :client do
    end

    devise_for :users, as: :client, path: '', controllers: {
      sessions: 'admin/users/sessions',
      registrations: 'admin/users/registrations'
    }
  end

end
