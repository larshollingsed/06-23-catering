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
  
  # Calculate the base wage for all events an employee worked but didn't manage
  # Returns a Float
  def get_base_wages
    events_worked = DB.execute("SELECT event_id FROM distributions WHERE employee_id = #{@id} AND manager is null;")
    
    set_of_events = []
    events_worked.each do |x|
      set_of_events << Event.find(x["event_id"].to_i)
    end
    
    wages = 0
    set_of_events.each do |x|
      wages += x.calc_base_wage + x.split_gratuity
    end
    wages
  end
  
  # Calculates the wages for all events an employee managed
  # Returns a Float
  def get_manager_wages
    events_managed = DB.execute("SELECT event_id FROM distributions WHERE employee_id = #{@id} AND manager = 'yes';")
    
    set_of_events = []
    events_managed.each do |x|
      set_of_events << Event.find(x["event_id"].to_i)
    end
    
    wages = 0
    set_of_events.each do |x|
      wages += x.calc_manager_wage
    end
    wages
  end
  
  # Calculates total wages earn
  # Return a Float
  def get_total_wages
    self.get_base_wages + self.get_manager_wages
  end
   
  # Calculates base wages employee earned in one month
  # month - Integer of the month number
  # Returns a Float
  def get_base_wages_for_month(month)
    # events_worked is an Array containing rows where this employee worked
    events_worked = DB.execute("SELECT event_id FROM distributions WHERE employee_id = #{@id} AND manager is null;")
    
    # Creates an Array of the event.ids of events in a specific month
    events_in_month = []
    Event.in_month(month).each do |x|
      events_in_month << x.id
    end
    
    # This pulls out just the event_id from the Array from the database
    set_of_events = []
    events_worked.each do |x|
      set_of_events << x["event_id"].to_i
    end
    
    # This uses "&" (intersection) to compare the event ids from the month
    #   and the events the employee has worked
    # events_employee_worked_this_month is an Array of event ids
    events_employee_worked_this_month = set_of_events & events_in_month
    
    # Turns the Array of event ids into an Array of Event objects
    paid_events = []
    events_employee_worked_this_month.each do |x|
      paid_events << Event.find(x)
    end
    
    # Uses methods from Events to calculate wages (including gratuity)
    wages = 0
    paid_events.each do |x|
      wages += x.calc_base_wage + x.split_gratuity
    end
    wages
  end
  
  # Calculates manager wages an employee earned in one month
  # month - Integer referring to the month number
  # Returns a Float
  def get_manager_wages_for_month(month)
    events_worked = DB.execute("SELECT event_id FROM distributions WHERE employee_id = #{@id} AND manager = 'yes';")
    
    events_in_month = []
    Event.in_month(month).each do |x|
      events_in_month << x.id
    end
    
    set_of_events = []
    events_worked.each do |x|
      set_of_events << x["event_id"].to_i
    end
    
    events_employee_worked_this_month = set_of_events & events_in_month
    
    paid_events = []
    events_employee_worked_this_month.each do |x|
      paid_events << Event.find(x)
    end
    
    wages = 0
    paid_events.each do |x|
      wages += x.calc_manager_wage
    end
    wages
  end
  
  # Calculates total wages for the month
  def get_total_wages_for_month(month)
    self.get_base_wages_for_month(month) + self.get_manager_wages_for_month(month)
  end
end