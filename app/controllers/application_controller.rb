class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def saludo
  	render html: "Hola cochino mundo"
  end
  
end
