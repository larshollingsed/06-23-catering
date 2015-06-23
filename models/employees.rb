require_relative "../database_instance_methods.rb"
require_relative "../database_methods.rb"

class Employee
  extend DatabaseClassMethods
  include DatabaseInstanceMethods
  
  attr_accessor :id, :name, :age

  def initialize(args={})
    @id = args["id"]
    @name = args["name"]
    @age = args["age"]
  end

# If the Employee is 19 or older they can serve alcohol
# Returns True/False  
  def can_serve_booze?
    @age >= 19
  end
  
end