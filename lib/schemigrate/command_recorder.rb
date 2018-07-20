module Schemigrate
  module CommandRecorder
    def create_foreign_connection *args
      record(:create_foreign_connection, args)
    end
  end
end
