require 'spec_helper'

describe 'Movie' do
  describe '#initialize' do
    it 'creates a movie' do
      test_movie = Movie.new({:name => "Adaptation"})
      expect(test_movie).to be_an_instance_of Movie
    end
  end

  describe '.all' do
    it 'returns an empty array' do
      expect(Movie.all).to eq []
    end
  end

  describe '#save' do
    it 'saves a movie to the movies table' do
      test_movie = Movie.new({:name => "THX 1138"})
      test_movie.save
      expect(Movie.all).to eq [test_movie]
    end
  end

  describe '.by_id' do
    it 'returns name of a movie when supplied a movie id' do
      test_movie = Movie.new({:name => "The Fifth Element"})
      testy_movie = Movie.new({:name => "Mood Indigo"})
      test_movie.save
      testy_movie.save
      expect(Movie.by_id(testy_movie.id)).to eq testy_movie
    end
  end

  describe '#delete' do
    it 'deletes a movie from the database' do
      test_movie = Movie.new({:name => "The Fifth Element"})
      test_movie.save
      testy_movie = Movie.new({:name => "Mood Indigo"})
      testy_movie.save
      movie1 = Movie.new({:name => "THX 1138"})
      movie1.save
      movie2 = Movie.new({:name => "Adaptation"})
      movie2.save
      Movie.delete(testy_movie.id)
      expect(Movie.all).to eq [test_movie,movie1,movie2]

    end
  end

  describe '#add_author' do
    it 'associates an author with a movie' do
      test_movie = Movie.new({:name => "THX 1138"})
      test_movie.save
      test_author = Author.new({:name => "George Lucas"})
      test_author.save
      test_author2 = Author.new({:name => "Robert Duvall"})
      test_author2.save
      test_movie.add_author(test_author.id)
      test_movie.add_author(test_author2.id)
      expect(test_movie.authors_names).to eq ["George Lucas", "Robert Duvall"]
    end
  end

  # describe '#add_copies' do
  #   it 'add a movie and total # of copies to copies table' do
  #     test_movie = Movie.new({:name => "THX 1138"})
  #     test_movie.save
  #     test_movie.add_copies(5)
  #     expect(test_movie.copies).to eq (5)
  #   end
  # end

end

