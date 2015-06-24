require_relative "../database_instance_methods.rb"
require_relative "../database_methods.rb"

class Distribution
  extend DatabaseClassMethods
  include DatabaseInstanceMethods
  
  attr_accessor :id, :employee_id, :event_id, :manager
  
  def initialize(args={})
    @id = args["id"]
    @employee_id = args["employee_id"]
    @event_id = args["event_id"]
    @manager = args["manager"]
  end
end
