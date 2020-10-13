Rails.application.routes.draw do
  resources :friendships
  resources :expert_topics
  get '/search_experts', to: 'expert_topics#expert_search'
  resources :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
