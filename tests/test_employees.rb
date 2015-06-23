require "minitest/autorun"
require "active_support.rb"
require_relative "../models/employees.rb"

class EmployeeTest < Minitest::Test
  def test_can_serve_booze?
    underage = Employee.new({"age" => 18})
    
    assert_equal(underage.can_serve_booze?, false)
    
    ofage = Employee.new({"age" => 50})
    
    assert_equal(ofage.can_serve_booze?, true)
  end
end
