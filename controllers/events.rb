get "/add_event" do
  erb :"/events/add_event_form"
end

get"/add_event_confirm" do
  @event_added = Event.add("name" => params["name"], "date" => params["date"], "hours" => params["hours"].to_f, "hourly_wage" => params["hourly_wage"].to_f, "gratuity" => params["gratuity"].to_f, "alcohol" => params["alcohol"])
  params["employee_id"].each do |x|
    if params["manager"] == x
      Distribution.add({"event_id" => @event_added.id, "employee_id" => x.to_i, "manager" => "yes"})
    else
      Distribution.add({"event_id" => @event_added.id, "employee_id" => x.to_i})
    end
  end
  erb :"/main/home"
end

get "/see_all_events" do
  erb :"/events/see_all_events"
end

get "/delete_event_form" do
  erb :"/events/delete_event_form"
end

get "/delete_event_confirm" do
  @event_deleted = Event.find(params["id"])
  @event_deleted.delete
  DB.execute("DELETE * FROM distributions where event_id = @event_deleted.id")
  erb :"/main/home"
end

get "/modify_event_form1" do
  erb :"/events/modify_event_form1"
end

get "/modify_event_form2" do
  erb :"/events/modify_event_form2"
end

get "/modify_event_confirm" do
  @event_modified = Event.new("id" => params["id"].to_i, "name" => params["name"], "date" => params["date"], "hours" => params["hours"].to_f, "hourly_wage" => params["hourly_wage"].to_f, "gratuity" => params["gratuity"].to_f, "alcohol" => params["alcohol"])
  @event_modified.save
  
  
  #TODO - delete all rows from distributions where event_id = @event_modified.id
  DB.execute("DELETE FROM distributions where event_id = #{@event_modified.id};")
  
  params["employee_id"].each do |x|
    if params["manager"] == x
      Distribution.add({"event_id" => @event_modified.id, "employee_id" => x.to_i, "manager" => "yes"})
    else
      Distribution.add({"event_id" => @event_modified.id, "employee_id" => x.to_i})
    end
  end
  erb :"/main/home"
end