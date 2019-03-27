module Schemigrate
  module SchemaStatements
    def create_foreign_connection foreign_schema
      database.create_fdw_extension foreign_schema
      database.create_server_connection foreign_schema
      database.create_user_mapping foreign_schema
      database.create_schema foreign_schema
      database.import_foreign_schema foreign_schema
    end
  private
    def database
      Schemigrate.database
    end
  end
end
