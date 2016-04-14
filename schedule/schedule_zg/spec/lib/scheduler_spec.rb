require 'spec_helper'
require 'schedule_zg/booking'
require 'schedule_zg/lesson'
require 'schedule_zg/scheduler'

describe ScheduleZg::Scheduler do
  describe '#add_lesson' do
    let(:scheduler) { described_class.new }
    let(:lesson) { double(ScheduleZg::Lesson) }

    subject { scheduler.add_lesson(lesson) }

    it 'adds the lesson to @lessons' do
      subject
      expect(scheduler.instance_variable_get(:@lessons)).to include(lesson)
    end
  end

  describe '#book' do
    let(:scheduler) { described_class.new }

    let(:request_student) { 'student' }
    let(:request_instructor) { 'instructor' }
    let(:request_type) { ScheduleZg::Lesson::GROUP_TYPE }
    let(:request_start_date) { Date.parse('2016-01-01') }
    let(:request_end_date) { Date.parse('2016-01-03') }
    let(:request_start_time) { Time.parse('00:00:00 EST') }
    let(:request_end_time) { Time.parse('01:00:00 EST') }
    let(:request_lesson) { lesson }

    let(:schedule_request) do
      ScheduleZg::ScheduleRequest.new(
        1,
        request_student,
        request_instructor,
        request_type,
        request_start_date,
        request_end_date,
        request_start_time,
        request_end_time,
        request_lesson
      )
    end

    let(:lesson_instructor) { 'instructor' }
    let(:lesson_type) { ScheduleZg::Lesson::GROUP_TYPE }
    let(:lesson_max_participants) { 2 }
    let(:lesson_start_date) { Date.parse('2016-01-01') }
    let(:lesson_end_date) { Date.parse('2016-01-03') }
    let(:lesson_start_time) { Time.parse('00:00:00 EST') }
    let(:lesson_end_time) { Time.parse('04:00:00 EST') }
    let(:lesson_duration) { 3600 }

    let(:lesson) do
      ScheduleZg::Lesson.new(
        lesson_instructor,
        lesson_type,
        lesson_max_participants,
        lesson_start_date,
        lesson_end_date,
        lesson_start_time,
        lesson_end_time,
        lesson_duration
      )
    end

    let(:lessons) { [lesson] }
    let(:bookings) { [] }

    let(:scheduled_bookings) { scheduler.instance_variable_get(:@bookings) }
    subject { scheduler.book(schedule_request) }

    before do
      scheduler.instance_variable_set(:@lessons, lessons)
      scheduler.instance_variable_set(:@bookings, bookings)
    end

    context 'when there are no bookings' do
      it 'successfully creates a booking for each day in the requested date range' do
        subject
        (request_start_date..request_end_date).each do |date|
          expect(scheduled_bookings).to include(
            ScheduleZg::Booking.new(
              request_student,
              date,
              request_start_time,
              request_end_time,
              request_lesson
            )
          )
        end
      end

      it 'returns an empty errors array' do
        subject
        expect(subject).to eq([])
      end
    end

    context 'when the group lesson is not full' do
      let(:lesson_max_participants) { 2 }
      let(:bookings) do
        [
          ScheduleZg::Booking.new(
            'student1',
            request_start_date,
            request_start_time,
            request_end_time,
            request_lesson
          )
        ]
      end

      it 'successfully creates a booking for each day in the requested date range' do
        subject
        (request_start_date..request_end_date).each do |date|
          expect(scheduled_bookings).to include(
            ScheduleZg::Booking.new(
              request_student,
              date,
              request_start_time,
              request_end_time,
              request_lesson
            )
          )
        end
      end

      it 'returns an empty errors array' do
        subject
        expect(subject).to eq([])
      end
    end

    context 'when the student has a conflicting booking' do
      let(:bookings) do
        [
          ScheduleZg::Booking.new(
            request_student,
            request_start_date,
            request_start_time,
            request_end_time,
            request_lesson
          )
        ]
      end

      it 'does not add the booking to the list of bookings' do
        subject
        expect(scheduled_bookings).to eq(bookings)
      end

      it 'includes "student not available" in the returned errors' do
        expect(subject).to include('student not available')
      end
    end

    context 'when there is no matching lesson offered at the requested time' do
      let(:lesson_instructor) { 'different_instructor' }

      it 'does not add the booking to the list of bookings' do
        subject
        expect(scheduled_bookings).to eq(bookings)
      end

      it 'includes "instructor not available" in the returned errors' do
        expect(subject).to include('instructor not available')
      end
    end

    context 'when the schedule request has an invalid duration' do
      before do
        allow(schedule_request).to receive_messages(valid_duration?: false)
      end

      it 'does not add the booking to the list of bookings' do
        subject
        expect(scheduled_bookings).to eq(bookings)
      end

      it 'includes "instructor not available" in the returned errors' do
        expect(subject).to include('instructor not available')
      end
    end

    context 'when the instructor has the requested time booked for another lesson' do
      let(:bookings) do
        [
          ScheduleZg::Booking.new(
            'different student',
            request_start_date,
            request_start_time,
            request_end_time,
            double(ScheduleZg::Lesson, instructor_name: request_instructor)
          )
        ]
      end

      it 'does not add the booking to the list of bookings' do
        subject
        expect(scheduled_bookings).to eq(bookings)
      end

      it 'includes "instructor not available" in the returned errors' do
        expect(subject).to include('instructor not available')
      end
    end

    context 'when the requested lesson is full' do
      let(:lesson_max_participants) { 2 }
      let(:bookings) do
        [
          ScheduleZg::Booking.new(
            'student1',
            request_start_date,
            request_start_time,
            request_end_time,
            request_lesson
          ),

          ScheduleZg::Booking.new(
            'student2',
            request_start_date,
            request_start_time,
            request_end_time,
            request_lesson
          ),
        ]
      end

      it 'does not add the booking to the list of bookings' do
        subject
        expect(scheduled_bookings).to eq(bookings)
      end

      it 'includes "instructor not available" in the returned errors' do
        expect(subject).to include('instructor not available')
      end
    end
  end
end
