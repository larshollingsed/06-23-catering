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
  
  # Returns a joined table with employee name, event name, event date
  # if they were the manager, and the event_id (to be used not displayed)
  def self.find_distributions_with_names
    DB.execute("SELECT employees.name, events.name AS event_name, events.date, distributions.manager, distributions.event_id FROM distributions INNER JOIN employees ON distributions.employee_id = employees.id INNER JOIN events ON distributions.event_id = events.id")
  end
  
  def self.delete_distributions_from_event(event_id)
    DB.execute("DELETE FROM distributions WHERE event_id = #{event_id}")
  end
  
end