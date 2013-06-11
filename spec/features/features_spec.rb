
describe "the signup process", :type => :feature do

  it "signs me in" do
    visit '/'
    within("#new_user") do
      fill_in 'user_email', :with => 'marcelo.braulio.si@gmail.com'
      fill_in 'user_password', :with => '12345678'
    end

    click_on 'Sign in'

    #page.should have_content 'Benvindo'
  end
end