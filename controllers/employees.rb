get "/see_all_employees" do
  erb :"/employees/see_all_employees"
end

get "/add_employee_form" do
  erb :"/employees/add_employee_form"
end

get "/add_employee_confirm" do
  @employee_added = Employee.add({"name" => params["employee"]["name"], "age" => params["employee"]["age"]})
  erb :"/main/home"
end

get "/delete_employee_form" do
  erb :"/employees/delete_employee_form"
end

get "/delete_employee_confirm" do
  @employee_deleted = Employee.find(params["id"])
  @employee_deleted.delete
  erb :"/main/home"
end

get "/modify_employee_form1" do
  erb :"/employees/modify_employee_form1"
end

get "/modify_employee_form2" do
  erb :"/employees/modify_employee_form2"
end

get "/modify_employee_confirm" do
  @employee_modified = Employee.new("id" => params["id"].to_i, "name" => params["name"], "age" => params["age"].to_i)
  @employee_modified.save
  erb :"/main/home"
end