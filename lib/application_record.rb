require 'active_record'

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true
end

ActiveRecord::Base.establish_connection(
  adapter: 'sqlite3',
  database: ':memory:'
)
