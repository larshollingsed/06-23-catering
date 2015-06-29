get "/home" do 
  @page_title = "Main Menu"
  erb :"main/home"
end