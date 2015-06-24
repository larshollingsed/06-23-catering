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
  
end
