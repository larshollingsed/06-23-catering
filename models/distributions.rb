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
  
  # Returns an Array of Hashes of rows from distributions where the employee worked
  def self.get_events_worked(employee_id)
    DB.execute("SELECT event_id FROM distributions WHERE employee_id = #{employee_id} AND manager is null;")
  end
  
  # Returns an Array of Hashes of rows from distributions where the employee managed
  def self.get_events_managed(employee_id)
    DB.execute("SELECT event_id FROM distributions WHERE employee_id = #{employee_id} AND manager = 'yes';")
  end
  
  def self.get_non_managers(employee_id)
    DB.execute("SELECT employee_id FROM distributions WHERE event_id = #{employee_id} AND manager is null")
  end
  
  def self.who_worked_an_event(event_id)
    DB.execute("SELECT employee_id FROM distributions WHERE event_id = #{event_id};")
  end
  
  # Returns the employee_id of the manager for this event
  def self.get_manager_id(event_id)
    DB.execute("SELECT employee_id FROM distributions WHERE manager = 'yes' and event_id = #{event_id};")[0]["employee_id"]
  end
  
  # Returns a joined table with employee name, event name, event date
  # if they were the manager, and the event_id (to be used not displayed)
  def self.find_distributions_with_names
    DB.execute("SELECT employees.name, events.name AS event_name, events.date, distributions.manager, distributions.event_id FROM distributions INNER JOIN employees ON distributions.employee_id = employees.id INNER JOIN events ON distributions.event_id = events.id")
  end
  
  def self.delete_distributions_from_event(event_id)
    DB.execute("DELETE FROM distributions WHERE event_id = #{event_id}")
  end
  
  def self.add_distributions(event_info, event_id)
    event_info["employee_id"].each do |x|
      if event_info["manager"] == x
        Distribution.add({"event_id" => event_id, "employee_id" => x.to_i, "manager" => "yes"})
      else
        Distribution.add({"event_id" => event_id, "employee_id" => x.to_i})
      end
    end
  end
  
end