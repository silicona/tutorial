class PublicacionesController < ApplicationController

	# Cap 13.3.1
	# Método usuario_accedido en app/controllers/application_controller.rb
	before_action :usuario_accedido, only: [:create, :destroy]

	# Cap 13.3.4 - Borrar publicaciones
	# Método privado, más abajo
	before_action :usuario_correcto, only: :destroy

	def create
		# Cap 13.3.2
		@publicacion = usuario_actual.publicaciones.build(params_de_publicacion)
		if @publicacion.save
			flash[:success] = '¡Has creado una publicación!'
			redirect_to root_url
		else
			# Cap 13.3.3 - Apaño para evitar excepcion por publicacion vacia
  		# Por ahora...
  		@objetos_suministro = []
  		# Por que no...?
  		#@objetos_suministro = usuario_actual.suministrar.paginate( page: params[:page] )			
			
			# Envia directamente a inicio para llevar los mensajes de error
			render 'paginas_estaticas/inicio'
		end

	end

	# Cap 13.3.4 - Borrar publicaciones
	def destroy
		@publicacion.destroy
		flash[:success] = "Publicación eliminada"

		# Redirecciona a la URL previa (que emitió la petición DELETE) o al root
		#redirect_to request.referrer || root_url
		# ==
		redirect_back(fallback_location: root_url) # Método de Rails 5
	end
	
	private

		# Cap 13.3.2
		# Whitelist de Publicaciones
		def params_de_publicacion
			
			#Cap 13.4.1
			#params.require(:publicacion).permit(:contenido)
			params.require(:publicacion).permit(:contenido, :imagen)
		end

		# Cap 13.3.4
		# True si usuario_actual tiene una publicacion con params[:id]
		def usuario_correcto
			@publicacion = usuario_actual.publicaciones.find_by(id: params[:id])
			redirect_to root_url if @publicacion.nil?
		end
end
