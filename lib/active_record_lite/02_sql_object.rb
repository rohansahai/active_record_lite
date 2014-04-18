require_relative 'db_connection'
require_relative '00_attr_accessor_object'
require 'active_support/inflector'

class SQLObject < AttrAccessorObject
  def self.columns
    if @column_names.nil?
      @column_names = DBConnection.execute2("SELECT * FROM #{self.table_name}")
      @column_names[0].each do |column_name|
        my_attr_accessor(column_name)
      end
      @column_names = @column_names[0]
    else
      @column_names
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    if @table_name.nil?
      @table_name = self.to_s.underscore.pluralize 
    else
      @table_name
    end
  end

  def self.all
    hash_objects = DBConnection.execute(<<-SQL)
    SELECT *
    FROM #{self.table_name}
    SQL
    ruby_objects = []
    hash_objects.each do |hash|
      ruby_objects << self.new(hash)
    end
    p ruby_objects
  end

  def self.find(id)
    # ...
  end

  def attributes
    @attributes ||= Hash.new(0)
  end

  def insert
    # ...
  end

  def initialize(params = {})
    params.each do |key, value|
      if self.class.columns.include?(key) 
        self.attributes[key.to_sym] = value
      else
        raise "Not a column" 
      end
    end
  end

  def save
    # ...
  end

  def update
    # ...
  end

  def attribute_values
    # ...
  end
end

class Cat < SQLObject
end

Cat.all