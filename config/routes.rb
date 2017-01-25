Rails.application.routes.draw do
  get 'paginas_estaticas/inicio'

  get 'paginas_estaticas/ayuda'

  resources :publicaciones
  resources :usuarios
  
  root :to => "usuarios#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
