# frozen_string_literal: true

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

  post '/meta', to: 'metas#add', as: 'meta_add'

  # views...
  get '/home', to: 'usuarios#home', as: 'user_home'
  get '/proyecto', to: 'proyectos#view', as: 'proyecto_view'
  get '/meta', to: 'metas#show', as: 'meta_show'

  get '/usuario_list', to: 'usuarios#user_list', as: 'user_list_view'

  get '/log_list', to: 'logs#view', as: 'logs_view'
  # stats
  # stat views
  get '/stats/week', to: 'stats#week', as: 'weekly_stats'
  get '/stats/meta', to: 'stats#meta', as: 'meta_stats'
  get '/stats/proyecto', to: 'stats#proyecto', as: 'proyecto_stats_view'
  get '/stats/usuario', to: 'stats#usuario', as: 'usuario_stats_view'

  # stat getters, info for other views.
  get '/stats/stat', to: 'stats#stats_for', as: 'stat_getter'

  resources :proyectos, only: %i[new create] do
    member do
      post 'completar'
      post 'finalizar'
      post 'pendiente'
    end
  end
  resources :metas, only: %i[new create] do
    member do
      post 'completar'
      post 'finalizar'
      post 'pendiente'
    end
  end
  resources :tareas, only: %i[new create] do
    member do
      post 'completar'
      post 'finalizar'
      post 'pendiente'
    end
  end
  resources :logs, only: [:index]
  resources :notificaciones, only: [:index]

  root 'sesiones#new' # Define the root path route to the login page
end