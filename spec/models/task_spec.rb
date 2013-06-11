require 'spec_helper'

describe Task do
  before(:each) do
    @task = FactoryGirl.create(:task)
  end

  it 'should be valid' do
    @task.should be_valid
  end

  it 'should be invalid without title' do
    @task.title = ''
    @task.should_not be_valid
  end

  it 'should be valid without a description' do
    @task.description = ''
    @task.should be_valid
  end

  it 'should be invalid without a completion date if completed' do
    @task.completed = true
    @task.valid?.should be_false
  end

  it 'should be complete if list is completed' do
    @list = @task.list
    @list.completed = true
    @list.finished_at = Time.now
    @list.save!
    @task.reload.completed.should be_true

  end
end
