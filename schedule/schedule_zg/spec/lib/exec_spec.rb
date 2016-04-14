require 'spec_helper'
require 'schedule_zg/exec'
require 'schedule_zg/scheduler'

describe ScheduleZg::Exec do
  describe '#exec' do
    let(:scheduler) { ScheduleZg::Scheduler.new }

    let(:lesson_csv_start_date) { '2016-01-01' }
    let(:lesson_csv_end_date) { '2016-01-03' }
    let(:lesson_csv_start_time) { '00:00:00 EST' }
    let(:lesson_csv_end_time) { '04:00:00 EST' }
    let(:lesson_csv_duration) { '1 hour' }

    let(:lesson_csv_obj) do
      {
        'Name' => lesson_instructor,
        'Training Type' => lesson_type,
        'Max Participants' => lesson_max_participants,
        'Start Date' => lesson_csv_start_date,
        'End Date' => lesson_csv_end_date,
        'Start Time' => lesson_csv_start_time,
        'End Time' => lesson_csv_end_time,
        'Duration' => lesson_csv_duration,
      }
    end

    let(:lesson_instructor) { 'instructor' }
    let(:lesson_type) { ScheduleZg::Lesson::GROUP_TYPE }
    let(:lesson_max_participants) { 2 }
    let(:lesson_start_date) { Date.parse(lesson_csv_start_date) }
    let(:lesson_end_date) { Date.parse(lesson_csv_end_date) }
    let(:lesson_start_time) { Time.parse(lesson_csv_start_time) }
    let(:lesson_end_time) { Time.parse(lesson_csv_end_time) }
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

    let(:schedule_request_csv_start_date) { '2016-01-01' }
    let(:schedule_request_csv_end_date) { '2016-01-03' }
    let(:schedule_request_csv_start_time) { '00:00:00 EST' }
    let(:schedule_request_csv_end_time) { '01:00:00 EST' }

    let(:schedule_request_csv_obj) do
      {
        'Request ID' => request_id,
        'Name' => request_student,
        'With' => request_instructor,
        'Training Type' => request_type,
        'Start Date' => schedule_request_csv_start_date,
        'End Date' => schedule_request_csv_end_date,
        'Start Time' => schedule_request_csv_start_time,
        'End Time' => schedule_request_csv_end_time,
      }
    end

    let(:request_id) { '1' }
    let(:request_student) { 'student' }
    let(:request_instructor) { 'instructor' }
    let(:request_type) { ScheduleZg::Lesson::GROUP_TYPE }
    let(:request_start_date) { Date.parse(schedule_request_csv_start_date) }
    let(:request_end_date) { Date.parse(schedule_request_csv_end_date) }
    let(:request_start_time) { Time.parse(schedule_request_csv_start_time) }
    let(:request_end_time) { Time.parse(schedule_request_csv_end_time) }
    let(:request_lesson) { lesson }

    let(:schedule_request) do
      ScheduleZg::ScheduleRequest.new(
        request_id,
        request_student,
        request_instructor,
        request_type,
        request_start_date,
        request_end_date,
        request_start_time,
        request_end_time
      )
    end

    let(:availabilty) { 'availabilty.csv' }
    let(:input) { 'input.csv' }

    subject { described_class.new.exec(availabilty, input) }

    before do
      allow(CSV)
        .to receive(:foreach)
        .with(availabilty, headers: true)
        .and_yield(lesson_csv_obj)
      allow(CSV)
        .to receive(:foreach)
        .with(input, headers: true)
        .and_yield(schedule_request_csv_obj)
      allow(ScheduleZg::Scheduler).to receive_messages(new: scheduler)
    end

    it 'adds the lessons in the availabilty csv to the scheduler lessons' do
      expect(scheduler).to receive(:add_lesson).with(lesson)
      subject
    end

    it 'attempts to book each request in the input csv' do
      expect(scheduler).to receive(:book).with(schedule_request).and_return([])
      subject
    end

    context 'when the schedule request has a conflict' do
      let(:errors) { ['error1', 'error2'] }
      let(:expected_output) do
        "\nRequest ID: #{request_id}\nReason for Conflict: #{errors.join(', ')}\n"
      end

      before do
        allow(scheduler).to receive_messages(book: errors)
      end

      it 'prints the reason for conflict' do
        expect { subject }.to output(expected_output).to_stdout
      end
    end
  end
end
