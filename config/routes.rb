Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "profile", to: "profile#show"
      resources :tasks, only: [:index, :create, :show, :update]
      resources :users, only: [:index]
    end
  end

  devise_for(
    :users,
    path: "auth",
    path_names: {
      sign_in: "sign_in",
      sign_out: "sign_out"
    }
  )

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
