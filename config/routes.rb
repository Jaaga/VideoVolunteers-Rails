Rails.application.routes.draw do
  devise_for :users
  devise_scope :user do
    root to: "devise/sessions#new"
  end

  get   'home'    =>   'static_pages#home'
  get   'about'   =>   'static_pages#about'
  get   'contact' =>   'static_pages#contact'
  resources :states, except: :destroy
  resources :users

  resources :ccs, except: :destroy do
    member do
      get :note_form
      patch :note
    end
  end

  match '/trackers/monthly', to: 'trackers#by_month', via: :get

  resources :trackers do
    member do
      get :note_form
      patch :note
    end
  end


end
