# Class to handle the main scheduling logic. Available lessons and existing bookings are represented as Arrays of
# Lessons and Bookings respectively. I chose arrays because The enumerable module makes it straight forward to search
# them and find bookings and lessons by different attributes and conditions.
module ScheduleZg
  class Scheduler
    def initialize
      @lessons  = []
      @bookings = []
    end

    # Public: Adds a lesson to the list of lesssons offered.
    #
    # lesson - the Lesson to add
    #
    # Returns the list of available lessons.
    def add_lesson(lesson)
      @lessons << lesson
    end

    # Public: Attempts to create a booking on the time and dates specified in the schedule request. If
    # the requested lesson is availble on the requested times and dates the booking is created, otherwise
    # a list of errors preventing creating the booking are returned.
    #
    # schedule_request - the schedule request made by the user
    #
    # Returns an Array of error strings if there are scheduling conflicts. If the booking is created
    # successfully an empty Array is returned.
    def book(schedule_request)
      errors = []

      # Make sure there is a matching lesson being offered
      schedule_request.lesson = get_lesson(schedule_request)

      errors << 'instructor not available' unless instructor_available?(schedule_request)
      errors << 'student not available' unless student_available?(schedule_request)

      return errors unless errors.empty?

      schedule_request.date_range.each do |date|
        @bookings << ScheduleZg::Booking.new(
          schedule_request.student,
          date,
          schedule_request.start_time,
          schedule_request.end_time,
          schedule_request.lesson
        )
      end

      errors
    end

    private

    # Internal: Checks whether the student is available during the requested times.
    #
    # schedule_request - the ScheduleRequest from the user
    #
    # Returns true if the student does not have any conflicting bookings during
    # the requested dates and times. False otherwise.
    def student_available?(schedule_request)
      @bookings.none? do |booking|
        booking.student.downcase == schedule_request.student.downcase &&
        schedule_request.date_range.cover?(booking.date) &&
        booking.start_time < schedule_request.end_time &&
        booking.end_time > schedule_request.start_time
      end
    end

    # Internal: Checks whether the instructor is available during the requested times.
    #
    # schedule_request - the ScheduleRequest from the user
    #
    # Returns true if the instructor does not have any conflicting bookings during
    # the requested dates and times. False otherwise.
    def instructor_available?(schedule_request)
      schedule_request.lesson &&
      schedule_request.valid_duration? &&
      slot_available?(schedule_request) &&
      !lesson_full?(schedule_request)
    end

    # Internal: Finds the lesson that matches the students request.
    #
    # schedule_request - the ScheduleRequest from the user
    #
    # Returns the Lesson if a matching lesson is found. nil is returned if no matching lesson is found.
    def get_lesson(schedule_request)
      @lessons.find do |lesson|
        lesson.instructor_name.downcase == schedule_request.instructor.downcase &&
        lesson.type == schedule_request.type &&
        lesson.start_date <= schedule_request.start_date &&
        lesson.end_date >= schedule_request.end_date &&
        lesson.start_time <= schedule_request.start_time &&
        lesson.end_time >= schedule_request.end_time
      end
    end

    # Internal: Checks whether the instructor has any other lessons booked during
    # during the same time as the requested lesson.
    #
    # schedule_request - the ScheduleRequest from the user.
    #
    # Returns false if the instructor has a different lesson scheduled during the same
    # block of time as requested. True otherwise.
    def slot_available?(schedule_request)
      # Get all bookings for the requested instructor that are not for the same
      # lesson at the the same time.
      instructor_bookings = @bookings.find_all do |booking|
        booking.lesson.instructor_name == schedule_request.instructor &&
        !(booking.lesson == schedule_request.lesson &&
          booking.start_time == schedule_request.start_time &&
          booking.end_time == schedule_request.end_time)
      end

      # Ensure that none of the instructors other bookings overlap conflict with
      # the requested times and dates.
      instructor_bookings.none? do |booking|
        schedule_request.date_range.cover?(booking.date) &&
        booking.start_time < schedule_request.end_time &&
        booking.end_time > schedule_request.start_time
      end
    end

    # Internal: Checks whether the given lesson has reached its max participation
    # level during the times requested.
    #
    # schedule_request - the ScheduleRequest from the user
    #
    # Returns false if all requested days in the range have at least one open
    # participation slot. True otherwise.
    def lesson_full?(schedule_request)
      # Get all other bookings for the requested lesson and time.
      lesson_bookings = @bookings.find_all do |booking|
        booking.lesson == schedule_request.lesson &&
        schedule_request.date_range.cover?(booking.date) &&
        booking.start_time == schedule_request.start_time &&
        booking.end_time == schedule_request.end_time
      end

      # Check that all the requested lessons have room for another participant.
      lesson_bookings
        .group_by { |booking| booking.date }
        .any? { |date, bookings| bookings.size >= schedule_request.lesson.max_participants }
    end
  end
end
