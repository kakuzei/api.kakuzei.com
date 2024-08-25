UUID_PATTERN = '[0-9a-f]{8}-([0-9a-f]{4}-){3}[0-9a-f]{12}'.freeze
UUID_REGEXP = /#{UUID_PATTERN}/
UUID_WITH_MAYBE_2X_REGEXP = /#{UUID_PATTERN}(@2x)?/

Rails.application.routes.draw do
  scope :api do
    get 'pictures', to: 'pictures#index', format: false
    get 'pictures/:id', to: 'pictures#show', id: UUID_REGEXP, format: false
    get 'pictures/:id', to: 'pictures#show', id: UUID_WITH_MAYBE_2X_REGEXP, format: 'jpg'
    get 'tags', to: 'tags#index', format: false
    get 'tags/:id', to: 'tags#show', id: UUID_REGEXP, format: false
    get 'tags/:tag_id/pictures', to: 'pictures#index', tag_id: UUID_REGEXP, format: false
  end
  get '*path', to: 'application#bad_request'
end
