env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, ENV["HEROKU_POSTGRESQL_SILVER_URL"] || "postgres://localhost/stackoverflow-api-#{env}")

DataMapper.finalize

DataMapper.auto_upgrade!