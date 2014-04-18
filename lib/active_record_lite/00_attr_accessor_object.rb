class AttrAccessorObject
  def self.my_attr_accessor(*names)
    names.each do |name|
      define_method("#{name}") {
        instance_variable_get("@#{name}")
      }
      
      define_method("#{name}=") do |arg|
        instance_variable_set("@#{name}", "#{arg}")
      end
    end
    
  end
end

# In the lib/00_attr_accessor_object.rb file, implement a ::my_attr_accessor macro,
#  which should do exactly the same thing as the real attr_accessor: it should define setter/getter methods.
# 
# To do this, use define_method to define getter and setter instance methods. 
#   You'll want to investigate and use the instance_variable_get and instance_variable_set methods described here.
# 
# There is a corresponding spec/00_attr_accessor_object_spec.rb spec file. Run it using rspec to check your work.