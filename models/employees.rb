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
  
  # Returns an Array of Hashes of rows from distributions where the employee worked
  def get_events_worked
    DB.execute("SELECT event_id FROM distributions WHERE employee_id = #{@id} AND manager is null;")
  end
  
  # Returns an Array of Hashes of rows from distributions where the employee managed
  def get_events_managed
    DB.execute("SELECT event_id FROM distributions WHERE employee_id = #{@id} AND manager = 'yes';")
  end
  
  # Calculate the base wage for all events an employee worked but didn't manage
  # Returns a Float
  def get_base_wages
    events_worked = get_events_worked
    set_of_events = Event.events_worked_to_objects(events_worked)
    Event.calc_wages_for_set_of_events(set_of_events)
  end
  
  # Calculates the wages for all events an employee managed
  # Returns a Float
  def get_manager_wages
    events_managed = get_events_managed
    set_of_events = Event.events_worked_to_objects(events_managed)
    Event.calc_manager_wages_for_set_of_events(set_of_events)
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
    events_worked = get_events_worked
    
    events_in_month = Event.events_in_month_ids(month)

    set_of_events = Event.get_event_ids_from_objects(events_worked)
    
    # This uses "&" (intersection) to compare the event ids from the month
    #   and the events the employee has worked
    # events_employee_worked_this_month is an Array of event ids
    events_employee_worked_this_month = set_of_events & events_in_month
    
    paid_events = Event.event_ids_to_objects(events_employee_worked_this_month)
    Event.calc_wages_for_set_of_events(paid_events)
  end
  
  # Calculates manager wages an employee earned in one month
  # month - Integer referring to the month number
  # Returns a Float
  def get_manager_wages_for_month(month)
    events_worked = get_events_managed
    
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
  
  def get_hours_for_month(month)
    # events_worked is an Array containing rows where this employee worked
    events_worked = DB.execute("SELECT event_id FROM distributions WHERE employee_id = #{@id};")
    
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
    
    hours = 0
    paid_events.each do |x|
      hours += x.hours
    end
    hours
  end
  
  
  
end