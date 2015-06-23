get "/see_all_employees" do
  erb :"/employees/see_all_employees"
end

get "/add_employee" do
  erb :"/employees/add_employee"
end

get "/add_employee_confirm" do
  Employee.add({"name" => params["name"], "age" => params["age"]})
  erb :"/main/home"
end

get "/delete_employee" do
  erb :"/employees/delete_employee"
end

get "/delete_employee_confirm" do
  Employee.find(params["id"]).delete
  erb :"/main/home"
end