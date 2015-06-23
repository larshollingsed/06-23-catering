get "/add_event" do
  erb :"/events/add_event_form"
end

get"/add_event_confirm" do
  @event_added = Event.add("date" => params["date"], "name" => params["name"], "hours" => params["hours"].to_f, "hourly_wage" => params["hourly_wage"].to_f, "gratuity" => params["gratuity"].to_i, "alcohol" => params["alcohol"])
  erb :"/main/home"
end

get "/see_all_events" do
  erb :"/events/see_all_events"
end