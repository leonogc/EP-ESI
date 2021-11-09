Rails.application.routes.draw do
  resources :markers
  get '/markers/:id/up' => "markers#upvote"
  get '/markers/:id/down' => "markers#downvote"

  root to: 'homes#index'
  get "homes" => "homes#index"
  get "index/user" => "homes#user"

  get    'login'   => 'sessions#new'
  post   'login'   => 'sessions#create'
  delete 'sign_out'  => 'sessions#destroy'
  
  get '/users/profile' => 'users#show'
  get '/users/edit' => 'users#edit'
  patch '/users/edit' => 'users#update'  
  resources :users

  get "authorities/login" => 'authorities#new'
  post "authorities/login" => 'authorities#create'
  get "authorities" => 'authorities#index'
  delete '/authorities/sign_out' => 'authorities#destroy'
end
