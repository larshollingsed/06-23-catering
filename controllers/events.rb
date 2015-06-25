get "/add_event" do
  erb :"/events/add_event_form"
end

get"/add_event_confirm" do
  # Sets of_age to true until made false
  @of_age = true
  
  # Goes through each employee added and makes sure they can serve booze
  if params["event"]["alcohol"] == "yes"
    params["event"]["employee_id"].each do |x|
      employee = Employee.find(x)
      # If the employee can't serve booze, this sets @of_age to false
      if employee.can_serve_booze? == false
        @of_age = false
      end
    end
  end
  
  # Checks to make sure @of_age is true.  If it is continues with adding the
  #   event and also adds it to the distributions table
  if @of_age
    @event_added = Event.add("name" => params["event"]["name"], "date" => params["event"]["date"], "hours" => params["event"]["hours"].to_f, "hourly_wage" => params["event"]["hourly_wage"].to_f, "gratuity" => params["event"]["gratuity"].to_f, "alcohol" => params["event"]["alcohol"])
    # Adds a manager "tag" if the employee was managing that event
    params["event"]["employee_id"].each do |x|
      if params["event"]["manager"] == x
        Distribution.add({"event_id" => @event_added.id, "employee_id" => x.to_i, "manager" => "yes"})
      else
        Distribution.add({"event_id" => @event_added.id, "employee_id" => x.to_i})
      end
    end
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
  @event_deleted = Event.find(params["id"])
  @event_deleted.delete
  DB.execute("DELETE FROM distributions WHERE event_id = #{@event_deleted.id}")
  erb :"/main/home"
end

get "/modify_event_form1" do
  erb :"/events/modify_event_form1"
end

get "/modify_event_form2" do
  erb :"/events/modify_event_form2"
end

# Modifies an events and its associated rows in distributions
get "/modify_event_confirm" do
  @event_modified = Event.new("id" => params["event"]["id"].to_i, "name" => params["event"]["name"], "date" => params["event"]["date"], "hours" => params["event"]["hours"].to_f, "hourly_wage" => params["event"]["hourly_wage"].to_f, "gratuity" => params["event"]["gratuity"].to_f, "alcohol" => params["event"]["alcohol"])
  
  @event_modified.save
  
  DB.execute("DELETE FROM distributions where event_id = #{@event_modified.id};")
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