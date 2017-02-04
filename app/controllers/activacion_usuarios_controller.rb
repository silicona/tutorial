class ActivacionUsuariosController < ApplicationController

	# Cap 11.3.2 - Activando Edit
	def edit
		usuario = Usuario.find_by(email: params[:email])
		if usuario && !usuario.activado? && usuario.autentificado?(:activacion, params[:id])

			# Cap 11.3.3 - Factorizado
			# Metodo activacion en modelo Usuario.rb
			usuario.activacion

			acceso_a usuario
			flash[:success] = "¡Cuenta activada!"

			redirect_to usuario

		else
			flash[:danger] = "¡El link de activación no es válido!"
			redirect_to root_url
		end
		
	end
end
