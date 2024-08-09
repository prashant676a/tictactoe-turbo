Rails.application.routes.draw do
  devise_for :users
  resources :games, only: %i[index new create show update] do
    member do
      get 'join'
      patch 'move/:row/:col', to: 'games#move', as: 'move'
    end
    collection do
      get 'join', to: 'games#join'
    end
  end

  root 'games#index'
end

