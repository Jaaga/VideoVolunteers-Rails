Rails.application.routes.draw do

  root                 'static_pages#home'
  get   'about'   =>   'static_pages#about'
  get   'contact' =>   'static_pages#contact'
  resources :states
  resources :ccs do
    member do
      get :note_form
      patch :note
    end
  end
  resources :trackers
end
