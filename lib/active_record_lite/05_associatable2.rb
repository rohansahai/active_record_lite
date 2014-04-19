require_relative '04_associatable'

# Phase V
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    

    define_method(name){ 
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      key_val = self.send(through_options.foreign_key)
      results = DBConnection.execute(<<-SQL, key_val)
      SELECT #{source_options.table_name}.*
      FROM #{source_options.table_name} s1 JOIN #{through_options.table_name} s2
      ON s1.id = s2.#{source_options.foreign_key}
      WHERE s2.id = ?
      SQL
      p results
      #self.class.parse_all(results)
    }
  end
end

# class Cat < SQLObject
#   belongs_to :human, foreign_key: :owner_id
#   has_one_through :home, :human, :house
# end
# 
# class Human < SQLObject
#   self.table_name = 'humans'
#   has_many :cats, foreign_key: :owner_id
#   belongs_to :house
# end
# 
# class House < SQLObject
#   has_many :humans
# end
# 
# cat = Cat.find(1)
# house = cat.home