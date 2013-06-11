require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the ListManagerHelper. For example:
#
# describe ListManagerHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe ListManagerHelper do
  it 'format the date' do
    time = Time.new(1988, 4, 23)
    (date_to_s(time) == "23/04/1988 00:00").should be_true
  end
end
