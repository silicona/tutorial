require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase




	test "Ayudante titulo_completo" do

		# Ayudante en app/helpers/application_helper.rb
		assert_equal titulo_completo, "Tutorial Rails"
		assert_equal titulo_completo("Ayuda"), "Ayuda | Tutorial Rails"
	end

	test "Ayudante acceso_a deberia estar ok" do
		
	end
end