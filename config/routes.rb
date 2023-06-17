Rails.application.routes.draw do

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

  get '/stats/week', to: 'stats#week', as: 'weekly_stats' 
  get '/adm', to: 'usuarios#admin', as: 'admin_view' 

  resources :proyectos, only: [:new, :create]
  resources :metas, only: [:new, :create]
  resources :tareas, only: [:new, :create, :show]
  resources :logs, only: [:index]
  resources :notificaciones, only: [:index]

  root 'sesiones#new' # Define the root path route to the login page
end