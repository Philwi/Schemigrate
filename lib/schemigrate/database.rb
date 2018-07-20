module Schemigrate
  class Database
    def create_fdw_extension server
      database_configuration[Rails.env].each_with_index do |s, index|
        server_config = database_configuration[Rails.env].values[index]
        case server_config['dbsystem']
        when 'MySQL'
          enable_extension :mysql_fdw
        when 'PostgreSQL'
          enable_extension :postgres_fdw
        else
          puts 'Wrong nor implemented database-system.'
        end
      end
    end

    def create_server_connection server
      database_configuration[Rails.env].each_with_index do |s, index|
        server_config = database_configuration[Rails.env].values[index]
				case server_config['dbsystem']
				when 'MySQL'
					execute <<-SQL
						CREATE SERVER IF NOT EXISTS #{server_config['service']}
						FOREIGN DATA WRAPPER mysql_fdw
						OPTIONS (host '#{server_config['host']}',
										port '#{server_config['port']}',
										dbname '#{server_config['dbname']}')
					SQL
				when 'PostgreSQL'
					execute <<-SQL
						CREATE SERVER IF NOT EXISTS #{server_config['service']}
						FOREIGN DATA WRAPPER postgres_fdw
						OPTIONS (host '#{server_config['host']}',
										port '#{server_config['port']}',
										dbname '#{server_config['dbname']}')
					SQL
				else
					puts 'Wrong nor implemented database-system.'
				end
			end
    end

		def create_user_mapping server
			database_configuration[Rails.env].each_with_index do |s, index|
				server_config = database_configuration[Rails.env].values[index]
				case server_config['dbsystem']
				when 'MySQL'
					execute <<-SQL
						CREATE USER MAPPING IF NOT EXISTS FOR#{current_user}
						SERVER #{server_config['service']}
						OPTIONS (username '#{server_config['user']}',
										password '#{server_config['password']}')
					SQL
				when 'PostgreSQL'
					execute <<-SQL
						CREATE USER MAPPING IF NOT EXISTS FOR #{current_user}
						SERVER #{server_config['service']}
						OPTIONS (user '#{server_config['user']}',
										password '#{server_config['password']}')
					SQL
				else
					puts 'Wrong nor implemented database-system.'
				end
			end
		end

		def create_schema server
			database_configuration[Rails.env].each_with_index do |s, index|
				server_config = database_configuration[Rails.env].values[index]
				execute <<-SQL
					CREATE SCHEMA IF NOT EXISTS #{server_config['service']}
				SQL
			end
		end

		def import_foreign_schema server
      binding.pry
			database_configuration[Rails.env].each_with_index do |s, index|
				server_config = database_configuration[Rails.env].values[index]
				if server_config['expect'].nil?
					puts "noch nicht implementiert"
				else
					execute <<-SQL
						IMPORT FOREIGN SCHEMA #{server_config['schema']}
						FROM SERVER #{server_config['service']}
						INTO #{server_config['service']}
					SQL
				end
			end
		end

    def current_user
      execute("SELECT CURRENT_USER").first['current_user']
    end

    delegate :execute, :enable_extension, to: :connection

    def connection
      ActiveRecord::Base.connection
    end

    def database_configuration
      yaml = Pathname.new('config/schemigrate.yml')
      YAML.load(ERB.new(yaml.read).result)
    end

  end
end
