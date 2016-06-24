Rails.application.routes.draw do



  resources :entries, :only => [:show, :edit, :destroy, :update] do
    
    resources :recordings, :only => [:create]

  end

  resources :dictionaries do
    resources :entries, :only => [:new, :create]

    resources :collaborators, :only => [:create, :destroy]
  end

  resources :users


  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'

  get 'signup' => 'users#new'
  post 'signup' => 'users#create'
  delete 'logout'  => 'sessions#destroy'



  get 'faq' => 'static_pages#faq'
  get 'about' => 'static_pages#about'
  get 'contact' => 'static_pages#contact'
  get 'home' => 'static_pages#home'

  root 'static_pages#home'
end
