# Cap 13.4.4 - Produccion - Sin pruebas en Heroku
# Se combina con Imagen_Uploader - if Rails.env.production?

## Pasos previos:
# 	Registrarse en Amazon Web Services
# 		https://aws.amazon.com/
# 	Crear una usuaria con AWS Identity and Access Management IAM y guardar
# 	la key de acceso y la secreta
# 		https://aws.amazon.com/iam/
# 	Crear un bucket S3 (con el nombre de tu gusto) usando la Consola AWS, para
# 	garantizar permisos d e lectura y escritura a la usuaria con IAM.

# 	Ver documentacion:
# 		https://aws.amazon.com/documentation/s3/

## Precaucion:
# 	Si el setup no funciona, puede ser por la localizacion de la region.
# 	Algunas usuarias quiza tengan que añadir a las credenciales de fog:
# 		:region => ENV['S3_REGION']
# 	Y despues, en la terminal:
# 		$ heroku config:set S3_REGION=<region bucket>
# 		<region bucket> ~= 'eu-central-1' o algo así.
# 	Ver Regiones y Findelmundo de Amazon:
# 		http://docs.aws.amazon.com/general/latest/gr/rande.html

if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      :provider              => 'AWS',
      :aws_access_key_id     => ENV['S3_ACCESS_KEY'],
      :aws_secret_access_key => ENV['S3_SECRET_KEY']
    }
    config.fog_directory     =  ENV['S3_BUCKET']
  end
end

# As with production email configuration (Listing 11.41), 
# 	we uses Heroku ENV variables to avoid hard-coding sensitive information. 

# In Section 11.4 and Section 12.4, these variables were defined automatically 
# 	via the SendGrid add-on, but in this case we need to define them explicitly, 
# 	which we can accomplish using heroku config:set as follows:

# $ heroku config:set S3_ACCESS_KEY=<access key>
# $ heroku config:set S3_SECRET_KEY=<secret key>
# $ heroku config:set S3_BUCKET=<bucket name>

## Se añade /public/uploads a .gitignore
# Lo digo, por dejarlo todo junto