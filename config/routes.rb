Rails.application.routes.draw do
  post  '/receive'     => 'pages#receive'
  get   '/about'       => 'pages#about'
  get   '/callback'    => 'pages#callback'
  get   '/privacy'     => 'pages#privacy'
  match '/delayed_job' => DelayedJobWeb, :anchor => false, via: [:get, :post]

  root to: 'pages#index'
end
