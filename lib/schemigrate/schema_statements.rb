module Schemigrate
  module SchemaStatements
    def create_foreign_connection foreign_server
      database.create_fdw_extension foreign_server
      database.create_server_connection foreign_server
      database.create_user_mapping foreign_server
      database.create_schema foreign_server
      database.import_foreign_schema foreign_server
    end
  private
    def database
      Schemigrate.database
    end
  end
end
