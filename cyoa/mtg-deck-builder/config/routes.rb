Rails.application.routes.draw do
  resources :users, :decks, :cards
  root                        'static_pages#home'
  get 'help'               => 'static_pages#help'
  get 'about'              => 'static_pages#about'
  get 'signup'             => 'users#new'
  get 'login'              => 'sessions#new'
  post 'login'             => 'sessions#create'
  delete 'logout'          => 'sessions#destroy'
  get 'types'              => 'types#index'
  get 'cards/:id/tooltip/' => 'cards#show_tooltip'
  post 'cards_decks'       => 'cards_decks#create', as: :add_card_to_deck
  delete 'cards_decks'     => 'cards_decks#destroy', as: :remove_card_from_deck
end
