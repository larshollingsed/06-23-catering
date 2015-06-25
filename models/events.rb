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

  # Checks to make sure underage employees aren't being added to an event
  #   with alcohol.
  # event - Hash (from a form) including "alcohol" => "yes" or => "no"
  #         and employee_id which is an Array containing employee id numbers
  # Returns True/False
  def self.can_all_employees_work?(event)
    @of_age = true
  
  # Goes through each employee added and makes sure they can serve booze
    if event["alcohol"] == "yes"
      event["employee_id"].each do |x|
        employee = Employee.find(x)
        # If the employee can't serve booze, this sets @of_age to false
        if employee.can_serve_booze? == false
          @of_age = false
        end
      end
    end
    @of_age
  end
  
end
