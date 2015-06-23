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
  
  
end