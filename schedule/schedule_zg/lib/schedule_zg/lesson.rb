# Object matching the schema from the instructor availabilty csv.
module ScheduleZg
  class Lesson
    GROUP_TYPE   = 'Group Lesson'
    PRIVATE_TYPE = 'Private Lesson'

    attr_accessor :instructor_name
    attr_accessor :type
    attr_accessor :max_participants
    attr_accessor :start_date
    attr_accessor :end_date
    attr_accessor :start_time
    attr_accessor :end_time
    attr_accessor :duration

    def initialize(instructor_name, type, max_participants, start_date, end_date, start_time, end_time, duration)
      self.instructor_name  = instructor_name
      self.type             = type
      self.max_participants = max_participants
      self.start_date       = start_date
      self.end_date         = end_date
      self.start_time       = start_time
      self.end_time         = end_time
      self.duration         = duration
    end

    def ==(other)
      other.respond_to?(:instructor_name) && other.instructor_name == instructor_name &&
      other.respond_to?(:type) && other.type == type &&
      other.respond_to?(:max_participants) && other.max_participants == max_participants &&
      other.respond_to?(:start_date) && other.start_date == start_date &&
      other.respond_to?(:end_date) && other.end_date == end_date &&
      other.respond_to?(:start_time) && other.start_time == start_time &&
      other.respond_to?(:end_time) && other.end_time == end_time &&
      other.respond_to?(:duration) && other.duration == duration
    end
  end
end
