require_relative 'db_connection'
require_relative '02_sql_object'

module Searchable
  def where(params)
    where_line = params.keys.join(" = ? AND ") + " = ?"
    results = DBConnection.execute(<<-SQL, *params.values)
    SELECT *
    FROM #{self.table_name}
    WHERE #{where_line}
    SQL
    results.map{ |result| self.new(result)}
  end
end

class SQLObject
  extend Searchable
  # Mixin Searchable here...
end

# class Cat < SQLObject
# end


# cats = Cat.where(name: 'Breakfast')
# p cat = cats.first
