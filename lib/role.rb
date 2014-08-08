class Role < Library

  def add_author author_id
    DB.exec("INSERT INTO authors_roles (author_id, role_id) VALUES ('#{author_id}', '#{self.id}');")
  end

  def authors_names
    authors = []
    results = DB.exec("SELECT authors.name FROM
      authors JOIN authors_roles ON (authors_roles.author_id = authors.id)
      WHERE roles.id = '#{self.id}';")
    results.each do |author|
      authors << author['name']
    end
    authors
  end
end
