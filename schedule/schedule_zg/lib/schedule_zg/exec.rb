# Entry point for the program. Handles parsing the CSVs, creating the scheduler,
# and printing any conflicts to stdout.

require 'csv'

module ScheduleZg
  class Exec
    def exec(availabilty, input)
      @scheduler = ScheduleZg::Scheduler.new

      CSV.foreach(availabilty, headers: true) do |csv_obj|
        @scheduler.add_lesson(create_lesson_from_csv(csv_obj))
      end

      CSV.foreach(input, headers: true) do |csv_obj|
        schedule_request = create_schedule_request_from_csv(csv_obj)
        errors = @scheduler.book(schedule_request)
        print_error_messages(schedule_request, errors) unless errors.empty?
      end
    end

    private

    def create_lesson_from_csv(csv_obj)
      ScheduleZg::Lesson.new(
        csv_obj['Name'],
        csv_obj['Training Type'],
        csv_obj['Max Participants'].to_i,
        DateTime.parse(csv_obj['Start Date']),
        DateTime.parse(csv_obj['End Date']),
        Time.parse(csv_obj['Start Time']),
        Time.parse(csv_obj['End Time']),
        parse_duration(csv_obj['Duration'])
      )
    end

    def create_schedule_request_from_csv(csv_obj)
      ScheduleZg::ScheduleRequest.new(
        csv_obj['Request ID'],
        csv_obj['Name'],
        csv_obj['With'],
        csv_obj['Training Type'],
        Date.parse(csv_obj['Start Date']),
        Date.parse(csv_obj['End Date']),
        Time.parse(csv_obj['Start Time']),
        Time.parse(csv_obj['End Time']),
      )
    end

    # Internal: Parses a string duration of the form '1 hour' to an integer of
    # the number of minutes in the duration.
    #
    # duration - the duration string to parsed
    #
    # Returns an Integer representing the length of the duration in minutes.
    def parse_duration(duration)
      quantity, unit = duration.split(' ')

      if unit =~ /[Mm]inute[s]?/
        (quantity.to_r * 60).to_i
      elsif unit =~ /[Hh]our[s]?/
        (quantity.to_r * 60 * 60).to_i
      end
    end

    def print_error_messages(schedule_request, errors)
      puts "\nRequest ID: #{schedule_request.id}\nReason for Conflict: #{errors.join(', ')}\n"
    end
  end
end
