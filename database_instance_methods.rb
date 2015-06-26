require "active_support"
require "active_support/inflector"

module DatabaseInstanceMethods

  # Creates a generalized table name for database modules
  # Returns a String of the table name
  def table_name
    self.class.to_s.pluralize.downcase
  end
  
  # Deletes a row in a table
  def delete

    DB.execute("DELETE FROM #{table_name} WHERE id = #{@id};")
  end
  
  def hash_to_object(x)  
    y = []
    x.each do |z|
      item = self.new(z)
      y << item
    end
    y
  end
  
  def save
    instance_variables = self.instance_variables
 
    attribute_hash = {}
 
    instance_variables.each do |variable|
      attribute_hash["#{variable.slice(1..-1)}"] = self.send("#{variable.slice(1..-1)}")
    end
 
    individual_instance_variables = []
 
    attribute_hash.each do |key, value|
      if value.is_a?(String)
        individual_instance_variables << "#{key} = '#{value}'"
      else
        individual_instance_variables << "#{key} = #{value}"
      end
    end
 
    for_sql = individual_instance_variables.join(', ')
 
    DB.execute("UPDATE #{table_name} SET #{for_sql} WHERE id = #{self.id}")
 
    return self
  end
  
end
