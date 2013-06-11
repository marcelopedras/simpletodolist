require 'spec_helper'

describe Favorite do
  before(:each) do
    @user1 = FactoryGirl.build(:user)
    @lista_public = FactoryGirl.build(:list, user: @user1, public: true)
    @user2 = FactoryGirl.build(:user, email: 'another@gmail.com')
  end



  it 'should be valid' do
    favorite = Favorite.new
    favorite.user = @user2
    favorite.list = @lista_public
    favorite.valid?.should be_true
  end

  it 'should be invalid when the list is private' do
    @lista_public.public = false
    @lista_public.save!
    favorite = Favorite.new
    favorite.user = @user2
    favorite.list = @lista_public
    favorite.valid?.should be_false
  end

  it 'should be invalid when the list belongs to myself' do
    favorite = Favorite.new
    favorite.user = @lista_public.user
    favorite.list = @lista_public
    favorite.valid?.should be_false
  end

  it 'should be invalid when there is already a favorite' do
    favorite = Favorite.new
    favorite.user = @user2
    favorite.list = @lista_public
    favorite.save!

    favorite2 = Favorite.new
    favorite2.user = @user2
    favorite2.list = @lista_public
    favorite2.valid?.should be_false
  end

  it 'should be invalid when it is not associated with a user' do
    favorite = Favorite.new
    favorite.list = @lista_public
    favorite.valid?.should be_false
  end

  it 'should be invalid when it is not associated with a list' do
    favorite = Favorite.new
    favorite.user = @user2
  end



end
