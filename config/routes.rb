Rails.application.routes.draw do
  # remove unwanted routes from resources
  put '/choose_appointment/:id', to: 'appointments#choose_appointment'
  resources :appointments, only: [ :index, :update, :destroy ]
  # Define your application routes per the DSL in https://gchoouides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
