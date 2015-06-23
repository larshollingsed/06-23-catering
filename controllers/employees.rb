get "/see_all_employees" do
  erb :"/employees/see_all_employees"
end

get "/add_employee" do
  erb :"/employees/add_employee"
end

get "/add_employee_confirm" do
  Employee.add({"name" => params["name"], "age" => params["age"]})
  erb :"main/home"
end