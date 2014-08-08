class Author < Library

  def add_movie movie_id
    DB.exec("INSERT INTO movies_authors (movie_id, author_id) VALUES ('#{movie_id}', '#{self.id}');")
  end

  def movies_titles
    movies = []
    results = DB.exec("SELECT movies.name FROM movies JOIN movies_authors ON (movies_authors.movie_id = movies.id) WHERE movies_authors.author_id = '#{self.id}';")
    results.each do |movie|
      movies << movie["name"]
    end
    movies
  end
end
