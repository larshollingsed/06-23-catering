get "/see_all_distributions_and_wages" do
  erb :"/distributions/see_all_distributions_and_wages"
end

get "/distribute_employees_to_event_form1" do
  erb :"/distributions/distribute_employees_to_event_form1"
end

get "/distribute_employees_to_event_form2" do
  erb :"/distributions/distribute_employees_to_event_form2"
end

get "/distribute_employees_to_event_confirm" do
  params["employee_id"].each do |x|
    if params["manager"] == x
      Distribution.add({"event_id" => params["event_id"].to_i, "employee_id" => x.to_i, "manager" => "yes"})
    else
      Distribution.add({"event_id" => params["event_id"].to_i, "employee_id" => x.to_i})
    end
  end
  erb :"main/home"
end