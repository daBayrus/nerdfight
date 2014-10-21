Rails.application.routes.draw do
  resources :teams, only: [ :index, :show, :new, :create ] do
    resources :questions, only: [ :new, :create ]
  end

  resources :play, only: [ :index ] do
    collection do
      get 'start'
      get 'quiz'
      get 'answers'
      post 'next'
      post 'buzz'
    end
  end

  resources :events, only: [ :index, :show, :new, :create ]

  root 'teams#new'
end
