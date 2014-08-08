require 'spec_helper'

describe 'Patron' do
  describe '#initialize' do
    it 'creates a patron' do
      test_patron = Patron.new({:name => "lil Joey"})
      expect(test_patron).to be_an_instance_of Patron
    end
  end

  describe '.all' do
    it 'returns an empty array' do
      expect(Patron.all).to eq []
    end
  end

  describe '#save' do
    it 'saves a patron to the patrons table' do
      test_patron = Patron.new({:name => "Bubba"})
      test_patron.save
      expect(Patron.all).to eq [test_patron]
    end
  end

  describe '.by_id' do
    it 'returns name of a patron when supplied a patron id' do
      test_patron = Patron.new({:name => "Your Mom"})
      testy_patron = Patron.new({:name => "The Mayor"})
      test_patron.save
      testy_patron.save
      expect(Patron.by_id(testy_patron.id)).to eq testy_patron
    end
  end

  describe '#delete' do
    it 'deletes a patron from the database' do
      test_patron = Patron.new({:name => "Your Mom"})
      test_patron.save
      testy_patron = Patron.new({:name => "The Mayor"})
      testy_patron.save
      patron1 = Patron.new({:name => "Bubba"})
      patron1.save
      patron2 = Patron.new({:name => "lil Joey"})
      patron2.save
      Patron.delete(testy_patron.id)
      expect(Patron.all).to eq [test_patron,patron1,patron2]
    end
  end

  describe '#checkout' do
    it 'checks out a movie to a patron for a week' do
      test_movie = Movie.new({:name => "THX 1138"})
      test_movie.save
      test_movie.add_copies(5)
      test_patron = Patron.new({:name => "lil Joey"})
      test_patron.save
      test_patron.checkout(test_movie.id)
      expect(test_patron.checked_out_movies).to eq ["THX 1138"]
    end
  end

  describe '#checked_in' do
    it 'changes the returned status to true' do
      test_movie = Movie.new({:name => "THX 1138"})
      test_movie.save
      test_movie.add_copies(5)
      test_patron = Patron.new({:name => "lil Joey"})
      test_patron.save
      test_patron.checkout(test_movie.id)
      test_patron.checked_in(test_movie.id)
      expect(test_patron.checked_out_movies).to eq []
    end
  end

  describe '#history' do
    it 'returns a patrons movie history' do
      test_movie = Movie.new({:name => "THX 1138"})
      test_movie.save
      another_test = Movie.new({:name => "Adaptation"})
      another_test.save
      test_movie.add_copies(5)
      another_test.add_copies(2)
      test_patron = Patron.new({:name => "lil Joey"})
      test_patron.save
      test_patron.checkout(test_movie.id)
      test_patron.checkout(another_test.id)
      test_patron.checked_in(test_movie.id)
      expect(test_patron.history).to eq ["Adaptation", "THX 1138"]
    end
  end

  describe '#due_date' do
    it 'returns a patrons checked out movies due date' do
      test_movie = Movie.new({:name => "THX 1138"})
      test_movie.save
      another_test = Movie.new({:name => "Adaptation"})
      another_test.save
      test_movie.add_copies(5)
      another_test.add_copies(2)
      test_patron = Patron.new({:name => "lil Joey"})
      test_patron.save
      test_patron.checkout(test_movie.id)
      test_patron.checkout(another_test.id)
      test_patron.checkout(another_test.id)
      test_patron.checked_in(test_movie.id)
      expect(test_patron.due_date(another_test.id)).to eq (Time.new + 604800).strftime("%Y%m%d")
    end
  end


  describe '#overdue' do
    it 'returns all of a patrons overdue movies' do
      test_movie = Movie.new({:name => "THX 1138"})
      test_movie.save
      this_test_movie = Movie.new({:name => "Fargo"})
      this_test_movie.save
      test_movie.add_copies(5)
      this_test_movie.add_copies(2)
      test_patron = Patron.new({:name => "lil Joey"})
      test_patron.save
      test_patron.checkout_overdue(test_movie.id)
      test_patron.checkout(this_test_movie.id)
      expect(test_patron.overdue).to eq ["THX 1138"]
    end
  end
end

