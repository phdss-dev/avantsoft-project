Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  resources :sales
  resources :clients
  resource :session
  resources :passwords, param: :token
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  get "statistics/sales_per_day" => "statistics#sales_per_day"
  get "statistics/top_clients", to: "statistics#top_clients"
  # Defines the root path route ("/")
  # root "posts#index"

  match "*any", to: "application#handle_routing_error", via: :all
end
