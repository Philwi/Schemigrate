# Schemigrate

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'schemigrate'
```

And then execute:

    $ bundle install

## Usage

### Connecting to a Remote Server

You will need to have a connection to a remote server before you can create a foreign table. This connection has to be created with connection information and user credentials for the foreign server in a `config/schemigrate.yml` file:

```yaml
development:
  foreign_server:
    host: 192.83.123.89
    port: 5432
    dbname: foreign_db
    user: foreign_user
    password: password
    schema:

production:
  foreign_server:
    host: 192.83.123.90
    port: 5432
    dbname: foreign_db
    user: foreign_user
    password: password
    schema:
```

Next you will need to create a migration to create the connection using a standard migration file like `db/migrate/[TIMESTAMP]_create_foreign_connection.rb:

```ruby
class CreateForeignConnection < ActiveRecord::Migration[5.0]
  def change
    create_foreign_connection :foreign_server
  end
end
```

Then you can run the migration as usual:

```sh
$ rake db:mibrate
```
