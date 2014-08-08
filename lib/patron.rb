class Patron < Library

  def checkout movie_id
    avail_copies = DB.exec("SELECT available_copies FROM copies WHERE movie_id = #{movie_id};").first['available_copies'].to_i
    unless avail_copies == 0
      result = DB.exec("SELECT id FROM copies WHERE movie_id = #{movie_id}").first['id'].to_i
      DB.exec("INSERT INTO checkouts (copies_id, patron_id, due_date) VALUES (#{result}, #{self.id}, '#{Time.new + 604800}');")
      avail_copies -= 1
      DB.exec("UPDATE copies SET available_copies = #{avail_copies} WHERE id = #{result}")
    else
      avail_copies
    end
  end

  def checked_out_movies
    checked_out = []
    results = DB.exec("SELECT movies.name FROM movies JOIN copies ON (movies.id = copies.movie_id) JOIN checkouts ON (copies.id = checkouts.copies_id) WHERE checkouts.patron_id = #{self.id};")
    results.each do |movie|
      checked_out << movie['name']
    end
    checked_out
  end
end
