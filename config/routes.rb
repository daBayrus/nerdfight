Rails.application.routes.draw do
  resources :teams, only: [ :show, :new, :create ] do
    resources :questions, only: [ :new, :create ]
  end

  root 'teams#new'
end
