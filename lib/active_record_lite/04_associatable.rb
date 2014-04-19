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
    # ...
  end

  def table_name
    # ...
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
    options = BelongsToOptions(name, options)
  end

  def has_many(name, options = {})
    options = HasManyOptions(name, options)
  end

  def assoc_options
    # Wait to implement this in Phase V. Modify `belongs_to`, too.
  end
end

class SQLObject
  # Mixin Associatable here...
end

options = BelongsToOptions.new('house')
