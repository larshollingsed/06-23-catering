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
  
  def calc_base_wage
    @hours * @hourly_wage
  end
  
  def calc_manager_wage
    @hours * @hourly_wage * 2
  end
  
  def split_gratuity
    non_managers = DB.execute("SELECT employee_id FROM distributions WHERE event_id = #{@id} AND manager is null")
    @gratuity / non_managers.count
  end
  
end
