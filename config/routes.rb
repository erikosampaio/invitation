Rails.application.routes.draw do

  root to: 'welcome#index'

  resources :users, except: [:show] do
    collection do
      get 'index_status',                to: 'users#index_status'
      get 'index_anfitriao',             to: 'users#index_anfitriao'
      get 'new_response_invitation',     to: 'users#new_response_invitation'
      post 'create_response_invitation', to: 'users#create_response_invitation'
      get 'resend_message',              to: 'users#resend_message'
      get 'trigger_message',             to: 'users#trigger_message'
    end
  end
end
