Rails.application.routes.draw do

  resources :articles
  mount Sagashi::Engine => "/sagashi"
end
