require_relative '03_searchable'
require 'active_support/inflector'

# Phase IVa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    self.class_name.constantize
    # ...
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})   
    options[:foreign_key].nil? ? self.foreign_key = (name.to_s + "_id").to_sym : self.foreign_key = options[:foreign_key]
    options[:primary_key].nil? ? self.primary_key = :id : self.primary_key = options[:primary_key]
    options[:class_name].nil? ? self.class_name = name.to_s.camelize : self.class_name = options[:class_name]
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    options[:foreign_key].nil? ? self.foreign_key = (self_class_name.downcase + "_id").to_sym : self.foreign_key = options[:foreign_key]
    options[:primary_key].nil? ? self.primary_key = :id : self.primary_key = options[:primary_key]
    options[:class_name].nil? ? self.class_name = name.to_s.singularize.camelize : self.class_name = options[:class_name]
  end
end

module Associatable
  # Phase IVb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)
    self.assoc_options[name] = options
    define_method(name){
      key = self.send(options.foreign_key)
      options.model_class.where(:id => key).first
    }
  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self.to_s, options)
    define_method(name){
      key = self.send(options.primary_key) 
      options.model_class.where(options.foreign_key => key)
    }
  end

  def assoc_options
    # Wait to implement this in Phase V. Modify `belongs_to`, too.
    @assoc_options = @assoc_options || {}
  end
end

class SQLObject
  extend Associatable
  # Mixin Associatable here...
end
