UUID_PATTERN ||= '[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}'.freeze

Rails.application.routes.draw do
  scope :api do
    get 'pictures', to: 'pictures#index', format: false
    get 'pictures/:id', to: 'pictures#show', id: /#{UUID_PATTERN}/, format: false
    get 'pictures/:id', to: 'pictures#show', id: /#{UUID_PATTERN}(@2x)?/, format: 'jpg'
    get 'tags', to: 'tags#index', format: false
    get 'tags/:id', to: 'tags#show', id: /#{UUID_PATTERN}/, format: false
    get 'tags/:tag_id/pictures', to: 'pictures#index', tag_id: /#{UUID_PATTERN}/, format: false
  end
  get '*path', to: 'application#bad_request'
end
