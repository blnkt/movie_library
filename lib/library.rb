class Library

  attr_reader :name, :id

  def initialize attributes
    @name = attributes[:name]
    @id = attributes[:id]
  end

  def save
    result = DB.exec("INSERT INTO #{self.class.to_s.downcase + 's'} (name) VALUES ('#{self.name}') RETURNING id;")
    @id = result.first['id'].to_i
  end

  def self.delete id
    DB.exec("DELETE FROM #{self.to_s.downcase + 's'} WHERE id = '#{id}';")
  end

    def self.all
    results = []
    DB.exec("SELECT * FROM #{self.to_s.downcase + 's'};").each do |result|
      results << self.new({:name => result["name"], :id => result["id"]})
    end
    results
  end

  def == name
    name == self.name
  end

  def self.by_id id
    result = DB.exec("SELECT * FROM #{self.to_s.downcase + 's'} WHERE id = '#{id}';")[0]
    target_object = self.new({:name => result['name'], :id => result['id']})
    target_object
  end

end
