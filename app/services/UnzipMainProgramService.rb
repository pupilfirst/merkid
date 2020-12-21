# .size bytes or what?

require 'pp'
require 'zip'

class UnzipMainProgramService
  attr_reader :student

  def initialize(student)
    @student = student
  end

  def extract!
    puts student.display_name

    return unless student.status == User::TASK_SUBMITTED

    submission = student.task_submissions.last
    return unless submission.main_program_text.blank?

    zip_contents = submission.uploaded_file.download
    begin
      Zip::File.open_buffer(zip_contents) do |zip|
        zip.each do |entry|
          filename = File.basename(entry.name).downcase
          puts filename
          next unless entry.file?
          next unless AutogradeService::CORRECT_FILENAMES.include?(filename)
          unzip_and_save!(entry, filename, submission)
          return true
        end
      end
    rescue Zip::Error
      return false
    end
    return false
  end

  private

  def unzip_and_save!(entry, filename, submission)
    contents = entry.size > 20_000 ? "File too large" : entry.get_input_stream.read
    result = [filename, "", contents].join("\n")
    submission.update_attributes!(main_program_text: result)
  end
end
