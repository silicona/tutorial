Rails.application.routes.draw do
  get 'pagina_estatica/Inicio'

  get 'pagina_estatica/Ayuda'

  resources :publicaciones
  resources :usuarios
  
  root :to => "usuarios#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
