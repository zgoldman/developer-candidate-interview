# Object representing a booking made by a user. The object represents a many to many relationship between students and
# lessons that they have booked.
module ScheduleZg
  class Booking
    attr_accessor :student
    attr_accessor :date
    attr_accessor :start_time
    attr_accessor :end_time
    attr_accessor :lesson

    def initialize(student, date, start_time, end_time, lesson)
      self.student    = student
      self.date       = date
      self.start_time = start_time
      self.end_time   = end_time
      self.lesson     = lesson
    end

    def ==(other)
      other.respond_to?(:student) && other.student == student &&
      other.respond_to?(:date) && other.date == date &&
      other.respond_to?(:start_time) && other.start_time == start_time &&
      other.respond_to?(:end_time) && other.end_time == end_time &&
      other.respond_to?(:lesson) && other.lesson == lesson
    end
  end
end
