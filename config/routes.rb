Rails.application.routes.draw do
  root to: "standings#index"
  resources :posses, only: [:index]
  namespace :api do
    namespace :v1 do
      resources :commands, only: [:create]
      resources :posses, only: [:index]
    end
  end
end
