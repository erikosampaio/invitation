Rails.application.routes.draw do  
  get 'welcome/index'
  resources :users
  get "home/index"  
  root to: "home#index"  
end 
