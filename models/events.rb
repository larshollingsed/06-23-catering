require_relative "../database_instance_methods.rb"
require_relative "../database_methods.rb"

class Event
  extend DatabaseClassMethods
  include DatabaseInstanceMethods

  attr_accessor :id, :name, :date, :hours, :hourly_wage, :gratuity, :alcohol

  def initialize(args={})
    @id = args["id"]
    @name = args["name"]
    @date = args["date"]
    @hours = args["hours"]
    @hourly_wage = args["hourly_wage"]
    @gratuity = args["gratuity"]
    @alcohol = args["alcohol"]
  end
  
  # Checks to see if the event served alcohol
  # Returns True/False
  def has_alcohol?
    @alcohol == "yes"
  end
  
  # Calculates the base wage for non-manager for an event
  # Returns a Float
  def calc_base_wage
    @hours * @hourly_wage
  end
  
  # Calculates the manager wage for an event
  # Returns a Float
  def calc_manager_wage
    @hours * @hourly_wage * 2
  end
  
  # Splits the gratuity depending on how many non-managers worked the event
  # Returns a Float
  def split_gratuity
    non_managers = DB.execute("SELECT employee_id FROM distributions WHERE event_id = #{@id} AND manager is null")
    @gratuity / non_managers.count
  end
  
  # Adds all hours for a set of events
  # paid_events is an Array of Events
  # Returns a Float of hours worked
  def self.total_hours_of_events(paid_events)
    hours = 0
    paid_events.each do |x|
      hours += x.hours
    end
    hours
  end

  # Checks to make sure underage employees aren't being added to an event
  #   with alcohol.
  # event - Hash (from a form) including "alcohol" => "yes" or => "no"
  #         and employee_id which is an Array containing employee id numbers
  # Returns True/False
  def self.can_all_employees_work?(event)
    of_age = true
  
    # Goes through each employee added and makes sure they can serve booze
    # Returns True/False
    if event["alcohol"] == "yes"
      event["employee_id"].each do |x|
        employee = Employee.find(x)
        # If the employee can't serve booze, this sets @of_age to false
        if employee.can_serve_booze? == false
          of_age = false
        end
      end
    end
    of_age
  end
  
  # Gets a set of events that occured in a month
  # month - Integer referring to the month number
  # Returns an array of Events
  def self.in_month(month)
    events = []
    Event.all.each do |x|
      if x.date.to_i == month
        events << x
      end
    end
    events
  end
  
  # Returns an Array of event ids in that month
  def self.event_ids_in_month(month)
    events_in_month = []
    # this calls the "in_month" method on Event based on the input from the form
    # and compiles an Array of Events
    event_objects_in_month = in_month(month)
    event_ids_in_month = []
    event_objects_in_month.each do |x|
      event_ids_in_month << x.id
    end
    event_ids_in_month
  end
  
  # Returns an Array containing Hashes with employee name, event name, event
  #   date, manager, and event.id for a given month
  def self.event_hashes_from_month(month)
    table = Distribution.find_distributions_with_names
    event_ids_in_month = Event.event_ids_in_month(month)

    # this pulls out only the rows(from my joined table) where the event occured
    # in the month specified by the user
    events_in_month = []
    table.each do |x|
      if event_ids_in_month.include?(x["event_id"])  
        events_in_month << x
      end
    end
    events_in_month
  end
  
  # Returns an array of employee_ids of those who worked this event
  def employees_who_worked
    employees_worked = []
    
    # gets employees who were designated as working this event previously
    DB.execute("SELECT employee_id FROM distributions WHERE event_id = #{@id};").each do |x|
      employees_worked << x["employee_id"]
    end
    employees_worked
  end
  
  # Returns the employee_id of the manager for this event
  def get_manager_id
    DB.execute("SELECT employee_id FROM distributions WHERE manager = 'yes' and event_id = #{@id};")[0]["employee_id"]
  end
  
  # events_worked is an Array of Hashes from the database 
  # Returns an Array of Events
  def self.events_worked_to_objects(events_worked)
    set_of_events = []
    events_worked.each do |x|
      set_of_events << self.find(x["event_id"].to_i)
    end
    set_of_events
  end
  
  # event_ids is an array of event ids
  # Returns an Array of Events
  def self.event_ids_to_objects(event_ids)
    paid_events = []
    event_ids.each do |x|
      paid_events << Event.find(x)
    end
    paid_events
  end
  
  
  def self.calc_wages_for_set_of_events(set_of_events)
    wages = 0
    set_of_events.each do |x|
      wages += x.calc_base_wage + x.split_gratuity
    end
    wages
  end
  
  def self.calc_manager_wages_for_set_of_events(set_of_events)
    wages = 0
    set_of_events.each do |x|
      wages += x.calc_manager_wage
    end
    wages
  end
  
  # Creates an Array of the event.ids of events in a specific month
  def self.events_in_month_ids(month)
    events_in_month = []
    Event.in_month(month).each do |x|
      events_in_month << x.id
    end
    events_in_month
  end
  
  def self.get_event_ids_from_objects(events_worked)
    set_of_events = []
    events_worked.each do |x|
      set_of_events << x["event_id"].to_i
    end
    set_of_events
  end
end
