class ReseteoPasswordsController < ApplicationController

  # cap 12.3.1
  before_action :obtener_usuario, only: [:edit, :update]
  before_action :usuario_valido, only: [:edit, :update]

  # Cap 12.3.2 - Update Caso 1 (ver al final, comentado)
  before_action :comprobar_expiracion, only: [:edit, :update]

  def new
  end

  # Cap 12.1.3
  def create 
  	@usuario = Usuario.find_by( email: params[:reseteo_password][:email].downcase)
  	if @usuario
  		@usuario.crear_reseteo_digest
  		@usuario.enviar_email_reseteo
  		flash[:info] = "email enviado con las instrucciones para resetear la contraseña"

  		redirect_to root_url
  	else
  		flash.now[:danger] = "La direccion email no ha sido encontrada"
  		render 'new'
  	end
  end

  def edit
  end

  # Cap 12.3.2
  def update
    if params[:usuario][:password].empty?   # Update Caso 3
      @usuario.errors.add(:password, "no puede estar vacia")
      render 'edit'
    elsif @usuario.update_attributes(parametros_usuario) # Update Caso 4
      acceso_a @usuario

      # Para evitar un acceso ajeno posterior, 
      #   se borra el reseteo_digest tras el acceso
      @usuario.update_attribute( :reseteo_digest, nil)
      flash[:success] = "La contraseña ha sido restablecida."
      redirect_to @usuario
    else    # update Caso 2
      render 'edit'
    end
  end

  private

    # Whitelist para update
    def parametros_usuario
      params.require(:usuario).permit( :password, :password_confirmation)
    end

    def obtener_usuario
      @usuario = Usuario.find_by(email: params[:email])
    end

    # Confirma que un usuario existe, esta activado, etc...
    def usuario_valido
      unless ( @usuario && @usuario.activado? && 
               @usuario.autentificado?(:reseteo, params[:id]))
        redirect_to root_url
      end
    end

    # Comprueba que el token_reseteo no está expirado
    def comprobar_expiracion

      # Método reseteo_password_expirado en Modelo Usuario.rb
      if @usuario.reseteo_password_expirado?
        mensaje = "El link para restablecer la contraseña ha expirado."
        mensaje += "Por favor, vuelva a solicitar el restablecimiento de su contraseña"
        flash[:danger] = mensaje
        redirect_to new_reseteo_password_url
      end
    end
end

# Update Casos posibles:

# 1 - Fallo por reseteo de password expirado

# 2 - Fallo por password invalido

# 3 - Fallo por password blank
#   El modelo permite password blank para la edicion del perfil de
#   usuario

# 4 - Actualizacion con éxito