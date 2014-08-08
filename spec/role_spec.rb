require 'spec_helper'

describe 'Role' do
  describe '#initialize' do
    it 'creates an author' do
      test_role = Role.new({:name => "Writer"})
      expect(test_role).to be_an_instance_of Role
    end
  end

  describe '.all' do
    it 'returns an empty array' do
      expect(Role.all).to eq []
    end
  end

  describe '#save' do
    it 'saves an author to the authors table' do
      test_role = Role.new({:name => "Director"})
      test_role.save
      expect(Role.all).to eq [test_role]
    end
  end

  describe '#add_role' do
    it 'associates an author with a role' do
      test_role = Role.new({:name => "Director"})
      test_role.save
      test_author = Author.new({:name => "George Lucas"})
      test_author.save
      test_role.add_role(test_author.id)
      expect(test_role.authors_names).to eq ["George Lucas"]
    end
  end
end
