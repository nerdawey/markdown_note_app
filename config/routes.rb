Rails.application.routes.draw do
  devise_for :users
  resource :user, only: [:show, :update]
  resources :notes, only: [:create, :index, :show]
  post 'notes/grammar_check', to: 'notes#grammar_check'
  get 'notes/:id/render_html', to: 'notes#render_html'
end