Rails.application.routes.draw do
  post '/receive'  => 'pages#receive'
  get  '/about'    => 'pages#about'
  get  '/callback' => 'pages#cb'
  get  '/privacy'  => 'pages#privacy'

  root to: 'pages#index'
end
