get "/see_all_employees" do
  erb :"/employees/see_all_employees"
end

get "/add_employee_form" do
  erb :"/employees/add_employee_form"
end

get "/add_employee_confirm" do
  @employee_added = Employee.add({"name" => params["name"], "age" => params["age"]})
  erb :"/main/home"
end

get "/delete_employee_form" do
  erb :"/employees/delete_employee_form"
end

get "/delete_employee_confirm" do
  Employee.find(params["id"]).delete
  erb :"/main/home"
end

get "/modify_employee_form" do
  erb :"/employees/modify_employee_form"
end

get "/modify_employee_form2" do
  erb :"/employees/modify_employee_form2"
end

get "/modify_employee_confirm" do
  updated_employee = Employee.new("id" => params["id"].to_i, "name" => params["name"], "age" => params["age"].to_i)
  updated_employee.save
  erb :"/main/home"
end