require 'immigrate/railtie'
require 'immigrate/database'

module Schemigrate
  def self.database
    @@database ||= Database.new
  end
end
