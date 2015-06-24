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
  
end
