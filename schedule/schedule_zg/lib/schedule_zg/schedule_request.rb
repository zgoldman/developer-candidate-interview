# Object matching the schema of the input csv. Has an extra attribute to point to the
# requested lesson to facilitate finding existing bookings relating to the request.
module ScheduleZg
  class ScheduleRequest
    attr_accessor :id
    attr_accessor :student
    attr_accessor :instructor
    attr_accessor :type
    attr_accessor :start_date
    attr_accessor :end_date
    attr_accessor :start_time
    attr_accessor :end_time
    attr_accessor :lesson

    def initialize(id, student, instructor, type, start_date, end_date, start_time, end_time, lesson = nil)
      self.id         = id
      self.student    = student
      self.instructor = instructor
      self.type       = type
      self.start_date = start_date
      self.end_date   = end_date
      self.start_time = start_time
      self.end_time   = end_time
      self.lesson     = lesson
    end

    def date_range
      (start_date..end_date)
    end

    def time_range
      (start_time..end_time)
    end

    def valid_duration?
      return false if lesson.nil? || start_time.nil? || end_time.nil?

      case lesson.type
      when ScheduleZg::Lesson::GROUP_TYPE then (end_time - start_time).to_i == lesson.duration
      when ScheduleZg::Lesson::PRIVATE_TYPE then ((end_time - start_time).to_i % lesson.duration) == 0
      else false
      end
    end

    def ==(other)
      other.respond_to?(:id) && other.id == id &&
      other.respond_to?(:student) && other.student == student &&
      other.respond_to?(:instructor) && other.instructor == instructor &&
      other.respond_to?(:type) && other.type == type &&
      other.respond_to?(:start_date) && other.start_date == start_date &&
      other.respond_to?(:end_date) && other.end_date == end_date &&
      other.respond_to?(:start_time) && other.start_time == start_time &&
      other.respond_to?(:end_time) && other.end_time == end_time &&
      other.respond_to?(:lesson) && other.lesson == lesson
    end
  end
end
