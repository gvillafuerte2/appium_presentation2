#  avm use 1.3.1 --no-reset
# bundle exec ruby simple_test.rb
# encoding: utf-8

require 'rubygems'
require 'appium_lib'

#  DESIRED CAPABILITIES
APP_PATH = '../../../../Library/Developer/Xcode/DerivedData/TestApp/Build/Products/Debug-iphonesimulator/TestApp.app'

desired_caps = {
  caps:       {
    platformName:  'ios',
    versionNumber: '8.1',
    deviceName:    'iPhone 6',
    app:           APP_PATH,
  },
}

# INICIA DRIVER
Appium::Driver.new(desired_caps).start_driver

module Calculator
  module IOS
    Appium.promote_singleton_appium_methods Calculator

    # calculando 2 num
    values       = [rand(10), rand(10)]
    expected_sum = values.reduce(&:+)

    # encuentra los elementos de tipo textield todos
    elements     = textfields

    elements.each_with_index do |element, index|
      element.type values[index]
    end

    # click en el primer boton
    button(1).click

    # obtiene valor de la suma
    actual_sum = first_text.text
    raise unless actual_sum == (expected_sum.to_s)
    #raise unless actual_sum == (30)

    # verifica que las alertas sean visibles
    button('show alert').click
    find_element :class_name, 'UIAAlert' # por:class_name

    # espera que las alertas estén visibles
    wait { text 'this alert is so cool' }

    # encuentra el boton cancelar y le da click
    find('Cancel').click

    # espera que se cierre la alerta
    wait_true { !exists { tag('UIAAlert') } }

    # modifica el texto de la alerta
    button('show alert').click # por:texto
    alert         = driver.switch_to.alert
    alerting_text = alert.text
    raise Exception unless alerting_text.include? 'Cool title'
    alert_accept #accepta la alerta

    # Cierra el driver log del resultado
    driver_quit
    puts 'Tests Succeeded!'
  end
end
