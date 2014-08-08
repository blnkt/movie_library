require 'spec_helper'

describe 'Author' do
  describe '#initialize' do
    it 'creates an author' do
      test_author = Author.new({:name => "Charlie Kaufman"})
      expect(test_author).to be_an_instance_of Author
    end
  end

  describe '.all' do
    it 'returns an empty array' do
      expect(Author.all).to eq []
    end
  end

  describe '#save' do
    it 'saves an author to the authors table' do
      test_author = Author.new({:name => "George Lucas"})
      test_author.save
      expect(Author.all).to eq [test_author]
    end
  end

  describe '.by_id' do
    it 'returns name of an author when supplied an author id' do
      test_author = Author.new({:name => "Luc Besson"})
      testy_author = Author.new({:name => "Michel Gondry"})
      test_author.save
      testy_author.save
      expect(Author.by_id(testy_author.id)).to eq testy_author
    end
  end

  describe '#delete' do
    it 'deletes an author from the database' do
      test_author = Author.new({:name => "Luc Besson"})
      test_author.save
      testy_author = Author.new({:name => "Michel Gondry"})
      testy_author.save
      author1 = Author.new({:name => "George Lucas"})
      author1.save
      author2 = Author.new({:name => "Charlie Kaufman"})
      author2.save
      Author.delete(testy_author.id)
      expect(Author.all).to eq [test_author,author1,author2]
    end

    it 'deletes an author from all tables' do
      author1 = Author.new({:name => "George Lucas"})
      author1.save
      testy_author = Author.new({:name => "Michel Gondry"})
      testy_author.save
      test_movie = Movie.new({:name => "THX 1138"})
      test_movie.save
      movietwo = Movie.new({:name => "Eternal Sunshine..."})
      movietwo.save
      author1.add_movie(test_movie.id)
      testy_author.add_movie(movietwo.id)
      Author.delete(author1.id)
      expect(Author.all).to eq [testy_author]
      expect(author1.movies_titles).to eq []
      expect(testy_author.movies_titles).to eq ["Eternal Sunshine..."]
    end
  end

  describe '#add_movie' do
    it 'associates a movie with an author' do
      test_movie = Movie.new({:name => "THX 1138"})
      test_movie.save
      testy_movie = Movie.new({:name => "American Graffiti"})
      testy_movie.save
      test_author = Author.new({:name => "George Lucas"})
      test_author.save
      test_author.add_movie(test_movie.id)
      test_author.add_movie(testy_movie.id)
      expect(test_author.movies_titles).to eq ["THX 1138", "American Graffiti"]
    end
  end

end

