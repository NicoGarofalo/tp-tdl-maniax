Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  get '/registro', to: 'usuarios#new', as: 'registro'
  post '/registro', to: 'usuarios#create'
  get '/iniciar_sesion', to: 'sesiones#new', as: 'iniciar_sesion'
  post '/iniciar_sesion', to: 'sesiones#create'
  delete '/cerrar_sesion', to: 'sesiones#destroy', as: 'cerrar_sesion'
  get '/success', to: 'sesiones#success', as: 'success'
  
  get '/meta', to: 'metas#show', as: 'meta_show'
  post '/meta', to: 'metas#add', as: 'meta_add'
  
  get '/home', to: 'usuarios#home', as: 'user_home'
  get '/proyecto', to: 'proyectos#view', as: 'proyecto_view'

  resources :proyectos, only: [:new, :create]
  resources :metas, only: [:new, :create]
  resources :tareas, only: [:new, :create]

  root 'sesiones#new' # Define the root path route to the login page
end