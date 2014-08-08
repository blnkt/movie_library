class Movie < Library

  def add_author author_id
    DB.exec("INSERT INTO movies_authors (movie_id, author_id) VALUES ('#{self.id}', '#{author_id}');")
  end

  def authors_names
    authors = []
    results = DB.exec("SELECT authors.name FROM
      authors JOIN movies_authors ON (movies_authors.author_id = authors.id)
      WHERE movies_authors.movie_id = '#{self.id}';")
    results.each do |author|
      authors << author['name']
    end
    authors
  end

  # def add_copies num_of_copies
  #   DB.exec("INSERT INTO copies (movie_id, num_of_copies) VALUES ('#{self.id}', '#{num_of_copies}');")
  # end

  # def copies
  #   DB.exec("SELECT num_of_copies FROM copies WHERE movie_id = '#{self.id}';")[0]['num_of_copies'].to_i
  # end
end
