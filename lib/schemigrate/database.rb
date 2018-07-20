module Schemigrate
  class Database
    def create_fdw_extension server
      server_config = database_configuration[Rails.env][server.to_s]
      case server_config['dbsystem']
      when 'MySQL'
        enable_extension :mysql_fdw
      when 'PostgreSQL'
        enable_extension :postgres_fdw
      else
        puts 'Wrong nor implemented database-system.'
      end
    end

    def create_server_connection server
      server_config = database_configuration[Rails.env][server.to_s]
      execute <<-SQL
        CREATE SERVER #{server}
        FOREIGN DATA WRAPPER postgres_fdw
        OPTIONS (host '#{server_config['host']}',
                 port '#{server_config['port']}',
                 dbname '#{server_config['dbname']}')
      SQL
    end

    def create_user_mapping server
      server_config = database_configuration[Rails.env][server.to_s]
      case server_config['dbsystem']
      when 'MySQL'
        execute <<-SQL
          CREATE USER MAPPING FOR #{current_user}
          SERVER #{server}
          OPTIONS (username '#{server_config['user']}',
                  password '#{server_config['password']}')
        SQL
      when 'PostgreSQL'
        execute <<-SQL
          CREATE USER MAPPING FOR #{current_user}
          SERVER #{server}
          OPTIONS (user '#{server_config['user']}',
                  password '#{server_config['password']}')
        SQL
      else
        puts 'Wrong nor implemented database-system.'
      end
    end

    def create_schema server
      server_config = database_configuration[Rails.env][server.to_s]
      execute <<-SQL
        CREATE SCHEMA #{server_config['service']}
      SQL
    end

    def import_foreign_schema server
      server_config = database_configuration[Rails.env][server.to_s]
      if server_config['expect'].nil?
        puts "noch nicht implementiert"
      else
        execute <<-SQL
          IMPORT FOREIGN SCHEMA #{server_config['schema']}
          FROM SERVER #{server}
          INTO #{server_config['service']}
        SQL
      end
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
