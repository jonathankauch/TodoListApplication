require 'spec_helper'

RSpec.describe Task do

  before do
    10.times do
      Task.create(content: 'test', status: 1)
    end
    10.times do
      Task.create(content: 'test', status: 0)
    end
  end

  it 'get 10 task in-progress' do
    nb = Task.in_progress
    expect(10).to eq nb.count
  end

  it 'get 10 task completed' do
    nb = Task.completed
    expect(10).to eq nb.count
  end

end
