class Patron < Library

  def checkout movie_id
    DB.exec("INSERT INTO checkouts (movie_id, patron_id, due_date) VALUES ('#{movie_id}', '#{self.id}', '#{Time.new}');")
    p DB.exec("SELECT * FROM checkouts;")[0]
  end

  def checked_out_movies
    checked_out = []
    results = DB.exec("SELECT movies.title FROM movies JOIN checkouts ON (checkouts.movie_id = movies.id) WHERE checkouts.patron_id = '#{self.id}';")
    results.each do |movie|
      checked_out << movie['title']
    end
    checked_out
  end
end
