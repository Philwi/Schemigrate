require 'schemigrate/railtie'
require 'schemigrate/database'
require 'schemigrate/version'

module Schemigrate
  def self.database
    @@database ||= Database.new
  end
end
