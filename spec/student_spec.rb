require_relative '../lib/student'

describe Student do
  before do
    DB[:conn].execute("DROP TABLE IF EXISTS students")
    Student.create_table
  end

  describe "attributes" do
    it 'has a name and a grade' do
      student = Student.new(nil, "John", 12)
      expect(student).to have_attributes(name: "John", grade: 12)
    end

    it 'has an id that defaults to `nil` on initialization' do
      student = Student.new(nil, "John", 12)
      expect(student.id).to eq(nil)
    end
  end

  describe ".create_table" do
    it 'creates the students table in the database' do
      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='students';"
      expect(DB[:conn].execute(table_check_sql)[0]).to eq(['students'])
    end
  end

  describe ".drop_table" do
    it 'drops the students table from the database' do
      Student.drop_table
      table_check_sql = "SELECT tbl_name FROM sqlite_master WHERE type='table' AND tbl_name='students';"
      expect(DB[:conn].execute(table_check_sql)[0]).to eq(nil)
    end
  end

  describe "#save" do
    it 'saves an instance of the Student class to the database and then sets the given student\'s id attribute' do
      student = Student.new(nil, "John", 12)
      student.save

      expect(student.id).to_not be_nil

    end
    it 'updates a record if called on an object that is already persisted' do
      student = Student.new(nil, "John", 12)
      student.save

      student.grade = 11
      student.save

      updated_student = Student.find_by_name("John")
      expect(updated_student.grade).to eq(11)
    end
  end

  describe ".create" do
    it 'creates a student with two attributes, name and grade, and saves it into the students table' do
      Student.create(name: "John", grade: 12)
      student = Student.find_by_name("John")
      expect(student).to_not be_nil
      expect(student.grade).to eq(12)
    end
  end

  describe ".new_from_db" do
    it 'creates an instance with corresponding attribute values' do
      student = Student.new_from_db([1, "John", 12])
      expect(student.id).to eq(1)
      expect(student.name).to eq("John")
      expect(student.grade).to eq(12)
    end
  end

  describe ".find_by_name" do
    it 'returns an instance of student that matches the name from the DB' do
      Student.create(name: "John", grade: 12)
      student = Student.find_by_name("John")
      expect(student).to_not be_nil
      expect(student.name).to eq("John")
      expect(student.grade).to eq(12)
    end
  end

  describe "#update" do
    it 'updates the record associated with a given instance' do
      student = Student.create(name: "John", grade: 12)
      student.grade = 11
      student.update

      updated_student = Student.find_by_name("John")
      expect(updated_student.grade).to eq(11)
    end
  end
end
