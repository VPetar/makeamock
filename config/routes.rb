Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions:      "users/sessions"
  }

  mount MissionControl::Jobs::Engine, at: "/jobs"

  get "inertia-example", to: "inertia_example#index"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"

  # Onboarding routes
  resources :onboarding, only: [ :index ] do
    collection do
      post :create_team
    end
  end

  # Invitation routes (public access via token)
  resources :invitations, param: :token, only: [ :show ] do
    member do
      patch :accept
      patch :decline
    end
  end

  # Team routes
  resources :teams, param: :guid, only: [] do
    namespace :teams do
      resources :invitations, only: [ :index, :create, :destroy ]
    end
  end

  namespace :api do
    get "*endpoint", to: "dynamic#index", constraints: { endpoint: %r{[^/]+(/[^/]+)*} }, as: :dynamic_index
    get "*endpoint/:id", to: "dynamic#show", constraints: { endpoint: %r{[^/]+(/[^/]+)*} }, as: :dynamic_show
    post "*endpoint", to: "dynamic#create", constraints: { endpoint: %r{[^/]+(/[^/]+)*} }, as: :dynamic_create
    put "*endpoint/:id", to: "dynamic#update", constraints: { endpoint: %r{[^/]+(/[^/]+)*} }, as: :dynamic_update
    patch "*endpoint/:id", to: "dynamic#update", constraints: { endpoint: %r{[^/]+(/[^/]+)*} }, as: :dynamic_patch
    delete "*endpoint/:id", to: "dynamic#destroy", constraints: { endpoint: %r{[^/]+(/[^/]+)*} }, as: :dynamic_destroy
  end

  namespace :dashboard do
    resources :home
    resources :models
  end

  get "*unmatched", to: "errors#not_found", constraints: lambda { |req|
    req.path.exclude? "rails/active_storage"
  }
end
