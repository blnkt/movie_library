require 'rspec'
require 'pg'
require 'pry'
require 'library'
require 'movie'
require 'author'
require 'patron'
require 'role'


DB = PG.connect({:dbname => 'movie_library_test'})
RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM authors *;")
    DB.exec("DELETE FROM movies *;")
    DB.exec("DELETE FROM patrons *;")
    DB.exec("DELETE FROM roles *;")
  end
end
