Rails.application.routes.draw do
  get 'paginas_estaticas/inicio'

  get 'paginas_estaticas/ayuda'

  get 'paginas_estaticas/acerca_de_nosotras'

  get 'paginas_estaticas/contacto'

  resources :publicaciones
  resources :usuarios
  
  root 'paginas_estaticas#inicio'
  # root original del tutorial
  #root :to => "application#saludo"

end
