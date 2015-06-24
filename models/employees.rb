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
  
  def get_base_wages
    events_worked = DB.execute("SELECT event_id FROM distributions WHERE employee_id = #{@id};")
    
    set_of_events = []
    events_worked.each do |x|
      set_of_events << Event.find(x["event_id"].to_i)
    end
    
    wages = 0
    set_of_events.each do |x|
      wages += x.calc_base_wage
    end
    wages
  end
  
end