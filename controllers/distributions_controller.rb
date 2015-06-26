get "/see_all_distributions_and_wages" do
  @table = Distribution.find_distributions_with_names
  erb :"/distributions/see_all_distributions_and_wages"
end

get "/distributions_and_wages_for_specific_month_form1" do
  erb :"/distributions/distributions_and_wages_for_specific_month_form1"
end

get "/distributions_and_wages_for_specific_month_form2" do
  @month = params["wages"]["month"].to_i
  @events_in_month = Event.event_hashes_from_month(@month)
  
  erb :"/distributions/distributions_and_wages_for_specific_month_form2"
end