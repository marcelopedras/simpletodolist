require 'spec_helper'

describe List do
  before(:each) do
    @user = FactoryGirl.build(:user)
    @list = FactoryGirl.build(:list)
    @task1 = FactoryGirl.create(:task, title: 'tarefa 1', list: @list)
    @task2 = FactoryGirl.create(:task, title: 'tarefa 2', list: @list)
  end

  it 'should be valid' do
    @list.should be_valid
  end

  it 'should be invalid without title' do
    @list.title = ''
    @list.should_not be_valid
    expect{@list.save!}.to raise_error
  end

  it 'should be invalid without user' do
    @list.user = nil
    @list.should_not be_valid
    expect{@list.save!}.to raise_error
  end

  it 'should be valid without description' do
    @list.description = ''
    @list.should be_valid
  end

  it 'should be invalid without a completion date if completed' do
    @list.completed = true
    @list.valid?.should be_false
  end

  it 'should be complete if all tasks is completed' do

    @list.completed.should be_false

    @task1.completed = true
    @task1.finished_at = Time.now

    @task2.completed = true
    @task2.finished_at = Time.now

    @task1.save!
    @task2.save!

    @list.reload.completed.should be_true
  end

  it 'all the tasks should be completed' do
    @list.all_tasks_completed?.should be_false
    @task1.completed = true
    @task2.completed = true
    @task1.finished_at = Time.now
    @task2.finished_at = Time.now
    @task1.save!
    @task2.save!
    @list.all_tasks_completed?.should be_true
  end

  it 'all tasks must be complete' do
    @task1.completed = true
    @task1.finished_at = Time.now
    @task1.save!
    @list.completed?.should be_false
    @list.complete_the_tasks_that_have_not_yet_been_completed
    @list.all_tasks_completed?.should be_true
  end

  it 'all tasks must be incomplete' do
    @list.complete_the_tasks_that_have_not_yet_been_completed
    @list.all_tasks_completed?.should be_true
    @list.undo_all_tasks
    @list.tasks.where(:completed =>true).count.should be_equal(0)
  end

  it 'should be returned only a list' do
    user = FactoryGirl.create(:user, email: 'fulano@gmail.com')
    another_user = FactoryGirl.create(:user, email: 'ze@gmail.com')

    public_list1 = FactoryGirl.create(:list, public: true, user: user)
    private_list1 = FactoryGirl.create(:list, public: false, user: user)


    public_list2 = FactoryGirl.create(:list, public: true, user: another_user)
    private_list2 = FactoryGirl.create(:list, public: false, user: another_user)

    lists = List.load_public_lists_except(user)
    lists.size.should be_equal(1)
    lists.first.id.should be_equal(public_list2.id)
  end

  it 'should be returned only a list by query' do
    user = FactoryGirl.create(:user, email: 'fulano@gmail.com')
    another_user = FactoryGirl.create(:user, email: 'ze@gmail.com')

    public_list1 = FactoryGirl.create(:list, public: true, title: 'xxxXXXxxxXXXxx', description: 'yyyYYyy', user: user)
    private_list1 = FactoryGirl.create(:list, public: false, title: 'xxxXXXxxxXXXxx', description: 'yyyYYyy', user: user)


    public_list2 = FactoryGirl.create(:list, public: true, title: 'xxxXXXxxxXXXxx', description: 'yyyYYyy', user: another_user)
    private_list2 = FactoryGirl.create(:list, public: false, title: 'xxxXXXxxxXXXxx', description: 'yyyYYyy',user: another_user)

    public_list3 = FactoryGirl.create(:list, public: true, title: 'aaaaa', description: 'bbbb', user: another_user)
    private_list3 = FactoryGirl.create(:list, public: false, title: 'aaaa', description: 'bbbb',user: another_user)

    lists = List.load_public_lists_by_condition_except(user, 'AAaA')
    lists.size.should be_equal(1)
    lists.first.id.should be_equal(public_list3.id)
  end


end
