Rails.application.routes.draw do
  scope :api do
    resources :pictures, only: %i[index show]
    resources :tags, only: %i[index show]
  end
  get '*path', to: 'application#bad_request'
end
