env = ENV["RACK_ENV"] || "development"

DataMapper.setup(:default, ENV["DATABASE_URL"] || "postgres://localhost/stackoverflow-api-#{env}")

DataMapper.finalize
