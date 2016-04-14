require 'spec_helper'
require 'schedule_zg/lesson'
require 'schedule_zg/schedule_request'

describe ScheduleZg::ScheduleRequest do
  describe '#date_range' do
    let(:start_date) { Date.new(2016, 1, 1) }
    let(:end_date) { Date.new(2016, 1, 2) }
    let(:schedule_request) { described_class.new(nil, nil, nil, nil, start_date, end_date, nil, nil) }

    it 'returns a range from start_date to end_date' do
      expect(schedule_request.date_range).to eq((start_date..end_date))
    end
  end

  describe '#time_range' do
    let(:start_time) { Time.new(2016, 1, 1, 1, 1, 1) }
    let(:end_time) { Time.new(2016, 1, 1, 2, 1, 1) }
    let(:schedule_request) { described_class.new(nil, nil, nil, nil, nil, nil, start_time, end_time) }

    it 'returns a range from start_date to end_date' do
      expect(schedule_request.time_range).to eq((start_time..end_time))
    end
  end

  describe '#valid_duration?' do
    let(:type) { nil }
    let(:duration) { nil }
    let(:lesson) { double(ScheduleZg::Lesson) }

    let(:start_time) { Time.new(2016, 1, 1, 1, 1, 1) }
    let(:end_time) { Time.new(2016, 1, 1, 2, 1, 1) }
    let(:schedule_request) { described_class.new(nil, nil, nil, nil, nil, nil, start_time, end_time, lesson) }

    subject { schedule_request.valid_duration? }

    before do
      allow(lesson).to receive_messages(duration: duration, type: type)
    end

    context 'when the lesson is a group lesson' do
      let(:type) { ScheduleZg::Lesson::GROUP_TYPE }

      context 'when the difference in start_time and end_time is the same as duration' do
        let(:duration) { (end_time - start_time).to_r }

        it 'returns true' do
          expect(subject).to be true
        end
      end

      context 'when the difference in start_time and end_time is a multiple of duration' do
        let(:duration) { 2 * (end_time - start_time).to_r }

        it 'returns false' do
          expect(subject).to be false
        end
      end

      context 'when the difference in start_time and end_time is a not multiple of duration' do
        let(:duration) { 2.1 * (end_time - start_time).to_r }

        it 'returns false' do
          expect(subject).to be false
        end
      end
    end

    context 'when the lesson is a private lesson' do
      let(:type) { ScheduleZg::Lesson::PRIVATE_TYPE }

      context 'when the difference in start_time and end_time is the same as duration' do
        let(:duration) { (end_time - start_time).to_i }

        it 'returns true' do
          expect(subject).to be true
        end
      end

      context 'when the difference in start_time and end_time is a multiple of duration' do
        let(:duration) { (end_time - start_time).to_i / 2 }

        it 'returns true' do
          expect(subject).to be true
        end
      end

      context 'when the difference in start_time and end_time is a not multiple of duration' do
        let(:duration) { 2 * (end_time - start_time).to_i }

        it 'returns false' do
          expect(subject).to be false
        end
      end
    end

    context 'when lesson type is invalid' do
      let(:type) { :invalid }

      it 'returns false' do
        expect(subject).to be false
      end
    end

    context 'when lesson is nil' do
      let(:lesson) { nil }

      it 'returns false' do
        expect(subject).to be false
      end
    end

    context 'when start_time is nil' do
      let(:start_time) { nil }

      it 'returns false' do
        expect(subject).to be false
      end
    end

    context 'when start_time is nil' do
      let(:end_time) { nil }

      it 'returns false' do
        expect(subject).to be false
      end
    end
  end
end
