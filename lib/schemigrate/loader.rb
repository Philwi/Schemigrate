require 'schemigrate/schema_statements'
require 'schemigrate/command_recorder'

class ActiveRecord::ConnectionAdapters::AbstractAdapter
  include Schemigrate::SchemaStatements
end

class ActiveRecord::Migration::CommandRecorder
  include Schemigrate::CommandRecorder
end
