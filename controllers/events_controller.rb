get "/add_event" do
  erb :"/events/add_event_form"
end

get"/add_event_confirm" do
  # Sets of_age to true if all employees can work and false if they can't
  @of_age = Event.can_all_employees_work?(params["event"])
  
  # Checks to make sure @of_age is true.  If it is continues with adding the
  #   event and also adds it to the distributions table
  if @of_age
    @event_added = Event.add("name" => params["event"]["name"], "date" => params["event"]["date"], "hours" => params["event"]["hours"].to_f, "hourly_wage" => params["event"]["hourly_wage"].to_f, "gratuity" => params["event"]["gratuity"].to_f, "alcohol" => params["event"]["alcohol"])
    
    Distribution.add_distributions(params["event"], @event_added.id)
    # Adds a manager "tag" if the employee was managing that event
    # params["event"]["employee_id"].each do |x|
    #   if params["event"]["manager"] == x
    #     Distribution.add({"event_id" => @event_added.id, "employee_id" => x.to_i, "manager" => "yes"})
    #   else
    #     Distribution.add({"event_id" => @event_added.id, "employee_id" => x.to_i})
    #   end
    # end
    erb :"/main/home"
  else
    # if @of_age was false, sends them back to the add event form
    erb :"/events/add_event_form"
  end
end

get "/see_all_events" do
  erb :"/events/see_all_events"
end

get "/delete_event_form" do
  erb :"/events/delete_event_form"
end

# Deletes the event and also deletes the associated rows in distributions
get "/delete_event_confirm" do
  @event_deleted = Event.find(params["event"]["id"])
  @event_deleted.delete
  Distribution.delete_distributions_from_event(@event_deleted.id)
  erb :"/main/home"
end

get "/modify_event_form1" do
  erb :"/events/modify_event_form1"
end

get "/modify_event_form2" do
  @event = Event.find(params["event"]["id"])
  @employees_worked = @event.employees_who_worked
  @manager_id = @event.get_manager_id
  erb :"/events/modify_event_form2"
end

# Modifies an events and its associated rows in distributions
get "/modify_event_confirm" do
  @event_modified = Event.new("id" => params["event"]["id"].to_i, "name" => params["event"]["name"], "date" => params["event"]["date"], "hours" => params["event"]["hours"].to_f, "hourly_wage" => params["event"]["hourly_wage"].to_f, "gratuity" => params["event"]["gratuity"].to_f, "alcohol" => params["event"]["alcohol"])
  
  @event_modified.save
  
  Distribution.delete_distributions_from_event(@event_modified.id)
  # Adds new rows to distributions, including checking for manager
  params["event"]["employee_id"].each do |x|
    if params["event"]["manager"] == x
      Distribution.add({"event_id" => @event_modified.id, "employee_id" => x.to_i, "manager" => "yes"})
    else
      Distribution.add({"event_id" => @event_modified.id, "employee_id" => x.to_i})
    end
  end
  
  erb :"/main/home"
end