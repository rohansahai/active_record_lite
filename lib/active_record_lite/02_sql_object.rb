require_relative 'db_connection'
require_relative '00_attr_accessor_object'
require 'active_support/inflector'

class SQLObject
  def self.columns
    if @column_names.nil?
      @column_names = DBConnection.execute2("SELECT * FROM #{self.table_name}")
      @column_names[0].each do |column_name|
        define_method("#{column_name}") {
          @attributes[column_name.to_sym]
        }
      
        define_method("#{column_name}=") do |arg|
          @attributes[column_name.to_sym] = arg
        end
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
    @table_name = "humans" if @table_name == "humen"
    @table_name
  end

  def self.all
    hash_objects = DBConnection.execute(<<-SQL)
    SELECT *
    FROM #{self.table_name}
    SQL
    self.parse_all(hash_objects)
  end
  
  def self.parse_all(hash_objects)
    ruby_objects = []
    hash_objects.each do |hash|
      ruby_objects << self.new(hash)
    end
    ruby_objects
  end

  def self.find(id)
    object = DBConnection.execute(<<-SQL)
    SELECT *
    FROM #{self.table_name}
    WHERE id = #{id}
    SQL
    self.new(object[0])
  end

  def attributes
    @attributes ||= Hash.new(nil)
  end

  def insert
    col_names = @attributes.keys.join(", ")
    question_marks = (["?"] * attribute_values.length).join(", ")
    DBConnection.execute(<<-SQL, *attribute_values)
    INSERT INTO
    #{self.class.table_name} (#{col_names})
    VALUES
    (#{question_marks})
    SQL
    self.id = DBConnection.last_insert_row_id
  end

  def initialize(params = {})
    self.attributes
    if params.empty?
      self.class.columns.each do|col_name|
        params[col_name]  = nil
      end
    end

    params.each do |key, value|
      if self.class.columns.include?(key.to_s)
        self.attributes[key.to_sym] = value
      else
        raise "Not a column" 
      end
    end
  end

  def save
    self.id.nil? ? insert : update
  end

  def update
    col_names = @attributes.keys.join(" = ?, ")
    DBConnection.execute(<<-SQL, *attribute_values)
    UPDATE
    #{self.class.table_name}
    SET
    #{col_names + " = ?"}
    WHERE
    id = #{self.id}
    SQL
  end

  def attribute_values
    values = []
    @attributes.each do |key, value|
      values << value
    end
    values
  end
end

class Cat < SQLObject
end

class Human < SQLObject
end

