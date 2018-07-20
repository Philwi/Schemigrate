require 'rails/railtie'

module Schemigrate
  class Railtie < Rails::Railtie
    initializer 'schemigrate.load' do
      ActiveSupport.on_load :active_record do
        require 'schemigrate/loader'
      end
    end
  end
end
