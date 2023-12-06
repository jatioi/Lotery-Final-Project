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
      resources :categories, except: :show
      resources :tickets, only: :index
      resources :winners do
        member do
          patch :submit
          patch :pay
          patch :ship
          patch :deliver
          patch :publish
          patch :remove_publish
        end
      end
      resources :offers, except: :show
      resources :orders, except: :show
    end
  end

  constraints(ClientDomainConstraint.new) do
    root "client/home#index", as: :client_root
    resources :client

    devise_for :users, as: :client, controllers: {
      sessions: 'client/users/sessions',
      registrations: 'client/users/registrations'
    }

    get "/me", to: 'client/me#index'
    get "/invite", to: 'client/invite#index'

    resources 'client/address', as: 'address', path: 'address', except: [:show, :edit]
    resources 'client/lottery', as: 'lottery', path: 'lottery', only: [:index, :show, :create]
    resources 'client/tickets', as: 'submit_tickets', path: 'submit_tickets', only: [:create]
    resources 'client/shop', as: 'shop', path: 'shop', only: [:index, :show]
    resources 'client/shop', as: 'purchase', path: 'shop', only: [:create]
    resources 'client/me/winnings', as: 'winning_history', path: 'me/winnings', only: [:index, :update] do
      member do
        get 'claim_prize', to: 'client/me/winnings#edit', as: 'claim_prize'
        get 'share_prize', to: 'client/me/winnings#edit_share', as: 'share_prize'
        patch 'update_share', to: 'client/me/winnings#update_share', as: 'update_share'
      end
    end
    resources 'client/me/orders', as: 'order_history', path: 'me/orders', only: :index
    resources 'client/me/lotteries', as: 'lottery_history', path: 'me/lotteries', only: :index
    resources 'client/me/winnings', as: 'winning_history', path: 'me/winnings', only: :index
    resources 'client/me/invites', as: 'invite_history', path: 'me/invites', only: :index
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


