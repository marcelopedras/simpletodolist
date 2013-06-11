require 'spec_helper'

describe User do
  before(:each) do
    @user = FactoryGirl.build(:user)
    @another_user = FactoryGirl.build(:user, email: 'anotheremail@gmail.com')
  end

  it 'should be valid' do
    @user.should be_valid
  end

  it 'should be invalid when email is not unique' do
    @user.save!
    @another_user.email = @user.email
    @another_user.valid?.should be_false
  end
end
