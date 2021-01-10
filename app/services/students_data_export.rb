require 'zip'

class StudentsDataExport
  def begin_export!
    filename = "/tmp/students-#{rand(1000)}"
    CSV.open(filename + '.csv', 'wb') do |csv|
      csv << User.column_names
      User.connection.select_all("select * from users").each do |row|
        csv << row.values
      end
    end

    # Zip and send because on Heroku, downloading large files might cross
    # its 30s timeout limit.
    Zip::File.open(filename + '.zip', Zip::File::CREATE) do |zipfile|
      zipfile.add('students.csv', filename + '.csv')
    end

    filename + '.zip'
  end
end
