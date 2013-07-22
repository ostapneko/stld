require_relative '../../test_helper'
require_relative '../../../models/sprint'

describe Sprint do

  before do
    DB[:sprints].delete
  end

  describe '.current' do
  it 'finds the last sprint' do
      sprint1 = Sprint.create(year: 2013, week: 1)
      sprint2 = Sprint.create(year: 2013, week: 20)
      Sprint.current.must_equal sprint2
      sprint3 = Sprint.create(year: 2014, week: 1)
      Sprint.current.must_equal sprint3
    end
  end

  describe '#overdue?' do
    before do
      @current_year = DateHelpers.current_year
      @current_week = DateHelpers.current_week
    end

    it 'returns true if the sprint is over' do
      sprint = Sprint.create(year: (@current_year - 1), week: @current_week)
      sprint.must_be :overdue?
    end

    it 'returns false if the sprint is not over' do
      sprint = Sprint.create(year: (@current_year + 1), week: @current_week)
      sprint.wont_be :overdue?
    end

    it 'returns false for the current sprint' do
      current_sprint = Sprint.create(year: @current_year, week: @current_week)
      current_sprint.wont_be :overdue?
    end
  end
end
