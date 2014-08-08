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

  def add_copies available_copies
    DB.exec("INSERT INTO copies (movie_id, available_copies) VALUES ('#{self.id}', '#{available_copies}');")
  end

  def copies
    DB.exec("SELECT available_copies FROM copies WHERE movie_id = '#{self.id}';")[0]['available_copies'].to_i
  end
end
