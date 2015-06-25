require "sinatra"
require "sinatra/reloader"
require "pry"

require "sqlite3"
require_relative "database_setup.rb"

require_relative "models/employees.rb"
require_relative "models/events.rb"
require_relative "models/distributions.rb"

require_relative "controllers/main_controller.rb"
require_relative "controllers/employees_controller.rb"
require_relative "controllers/events_controller.rb"
require_relative "controllers/distributions_controller.rb"
