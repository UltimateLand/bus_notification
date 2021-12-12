Rails.application.routes.draw do
  resources :receivers, only: %i[new create]
  root to: 'application#about'
end
