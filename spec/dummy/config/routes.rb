Rails.application.routes.draw do
  resources :articles
  get 'search', to: 'articles#search'
  mount Sagashi::Engine => "/sagashi"
end
