Rails.application.routes.draw do
  # Creadas por Rails. Anuladas por Cap 12.1
  # get 'reseteo_passwords/new'
  # get 'reseteo_passwords/edit'

  root 'paginas_estaticas#inicio'
  # root original del tutorial
  #root :to => "application#saludo"

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

# Capitulo 7.2 - listado 7.26
  # Añadiendo la ruta de registro para las peticiones post
  # Para que get y post tengan url "/registro"
  post '/registro', to: 'usuarios#create'

# Capitulo 8
  # Controlador Sesiones
  # Recurso Sesiones solo usa rutas nombradas

  # Creado por Rails, anulado por Tutorial
  #get 'sesiones/new'

  get '/acceder', to: "sesiones#new"
  post '/acceder', to: 'sesiones#create'
  delete '/cerrar', to: 'sesiones#destroy'
  
# Capitulo 7
  resources :usuarios
# via $ rake routes
# GET    /usuarios(.:format)    usuarios_path          usuarios#index
# POST   /usuarios(.:format)                           usuarios#create
# GET    /usuarios/new(.:for)   new_usuario_path       usuarios#new
# GET    /usuarios/:id/edit(.:for) edit_usuario_path(usuario) usuarios#edit
# GET    /usuarios/:id(.:for)   usuario_path(usuario)  usuarios#show
# PATCH  /usuarios/:id(.:for)   usuario_path(usuario)  usuarios#update
# PUT    /usuarios/:id(.:for)   usuario_path(usuario)  usuarios#update
# DELETE /usuarios/:id(.:for)   usuario_path(usuario)  usuarios#destroy
  
# Capitulo 11.1 Activacion de usuarios
  resources :activacion_usuarios, only: [:edit]  

# Capitulo 12.1 Reseteo de passwords
  resources :reseteo_passwords, only: [:new, :create, :edit, :update]


end
