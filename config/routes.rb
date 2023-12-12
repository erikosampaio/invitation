Rails.application.routes.draw do

  root to: 'welcome#index'

  resources :users, except: [:show] do
    collection do
      get 'index_status',                to:'users#index_status'
      get 'new_response_invitation',     to:'users#new_response_invitation'
      post 'create_response_invitation', to: 'users#create_response_invitation'
    end
  end
end
