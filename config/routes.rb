Rails.application.routes.draw do
  resources :teams, only: [ :index, :show, :new, :create ] do
    resources :questions, only: [ :new, :create ]
  end

  resources :play, only: [:index] do
    collection do
      get 'start'
      post 'next'
    end
  end

  root 'teams#new'
end
