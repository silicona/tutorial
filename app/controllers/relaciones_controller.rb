class RelacionesController < ApplicationController

	# Cap 14.2.5 - Se sustituye usuario por @usuario para Ajax

	# Control de acceso básico
	before_action :usuario_accedido

	def create
		@usuario = Usuario.find(params[:seguido_id])
		usuario_actual.seguir(@usuario)
		# Cap 14.2.5 - Preparado para responder a Ajax
		#redirect_to usuario
		respond_to do |formato|
			formato.html {redirect_to @usuario}
			formato.js
		end
	end

	def destroy
		@usuario = Relacion.find(params[:id]).seguido
		usuario_actual.dejar_de_seguir(@usuario)
		# Cap 14.2.5 - Preparado para responder a Ajax
		#redirect_to usuario
		respond_to do |formato|
			formato.html {redirect_to @usuario}
			formato.js
		end
	end
end
