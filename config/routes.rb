Rails.application.routes.draw do
  # Anulado por gets hacia Controlador páginas_estáticas
  # get 'paginas_estaticas/inicio'
  # get 'paginas_estaticas/ayuda'
  # get 'paginas_estaticas/acerca_de_nosotras'
  # get 'paginas_estaticas/contacto'

  # GET hacia Controladores

  # Anulado por root
  # get '/inicio' => "paginas_estaticas#inicio", as: "inicio"
  get '/ayuda', to: 'paginas_estaticas#ayuda'
  get '/acerca_de_nosotras' => 'paginas_estaticas#acerca_de_nosotras', as: "acerca"
  get '/contacto' => 'paginas_estaticas#contacto'

  # CRUD sin resources - Cambian los path y url:
  #    usuarios_new <=> new_usuario
  get '/registro', to: 'usuarios#new'
  # Anulado por get '/registro'
  # get 'usuarios/new'

  resources :publicaciones
  #resources :usuarios
  
  root 'paginas_estaticas#inicio'
  # root original del tutorial
  #root :to => "application#saludo"

end
