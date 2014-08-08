class Patron < Library

  def checkout movie_id
    date = (Time.new + 604800).strftime("%Y%m%d").to_i
    avail_copies = DB.exec("SELECT available_copies FROM copies WHERE movie_id = #{movie_id};").first['available_copies'].to_i
    unless avail_copies == 0
      result = DB.exec("SELECT id FROM copies WHERE movie_id = #{movie_id}").first['id'].to_i
      DB.exec("INSERT INTO checkouts (copies_id, patron_id, due_date, returned) VALUES (#{result}, #{self.id}, #{date}, false);")
      avail_copies -= 1
      DB.exec("UPDATE copies SET available_copies = #{avail_copies} WHERE id = #{result}")
    else
      avail_copies
    end
  end

  def checkout_overdue movie_id
    date = (Time.new - 604800).strftime("%Y%m%d").to_i
    avail_copies = DB.exec("SELECT available_copies FROM copies WHERE movie_id = #{movie_id};").first['available_copies'].to_i
    unless avail_copies == 0
      result = DB.exec("SELECT id FROM copies WHERE movie_id = #{movie_id}").first['id'].to_i
      DB.exec("INSERT INTO checkouts (copies_id, patron_id, due_date, returned) VALUES (#{result}, #{self.id}, '#{date}', false);")
      avail_copies -= 1
      DB.exec("UPDATE copies SET available_copies = #{avail_copies} WHERE id = #{result}")
    else
      avail_copies
    end
  end

  def checked_out_movies
    checked_out = []
    results = DB.exec("SELECT movies.name FROM movies JOIN copies ON (movies.id = copies.movie_id) JOIN checkouts ON (copies.id = checkouts.copies_id) WHERE checkouts.patron_id = #{self.id} AND checkouts.returned = false;")
    results.each do |movie|
      checked_out << movie['name']
    end
    checked_out
  end

  def checked_in movieID
    results = DB.exec("SELECT checkouts.id FROM movies JOIN copies ON (movies.id = copies.movie_id) JOIN checkouts ON (copies.id = checkouts.copies_id) WHERE checkouts.patron_id = #{self.id} AND checkouts.returned = false AND movies.id = #{movieID};").first['id'].to_i
    DB.exec("UPDATE checkouts SET returned = true WHERE patron_id = #{self.id} AND id = #{results};")
  end

  def history
    movie_history = []
    results = DB.exec("SELECT movies.name FROM movies JOIN copies ON (movies.id = copies.movie_id) JOIN checkouts ON (copies.id = checkouts.copies_id) WHERE checkouts.patron_id = #{self.id};")
    results.each do |movie|
      movie_history << movie['name']
    end
    movie_history.sort
  end

  def due_date(movieID)
    results = DB.exec("SELECT checkouts.due_date FROM movies JOIN copies ON (movies.id = copies.movie_id) JOIN checkouts ON (copies.id = checkouts.copies_id) WHERE patron_id = #{self.id} AND movies.id = #{movieID}").first['due_date']
    results
  end

  def overdue
    overdue_movies = []
    results = DB.exec("SELECT movies.name FROM movies JOIN copies ON (movies.id = copies.movie_id) JOIN checkouts ON (copies.id = checkouts.copies_id) WHERE checkouts.patron_id = #{self.id} AND checkouts.returned = false AND due_date < #{Time.new.strftime("%Y%m%d").to_i};")
    results.each do |movie|
      overdue_movies << movie['name']
    end
    overdue_movies
  end
end
