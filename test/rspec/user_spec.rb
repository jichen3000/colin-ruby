# gem install rspec

# run "spec user_spec.rb --format specdoc"
require "User"


describe User do
  it "should be in any roles assigned to it" do
    user = User.new
    role = "assigned role"
    user.assign_role(role)
    user.should be_in_role(role)  end
  it "should NOT be in any roles not assigned to it" do
    user = User.new
    role = "unassigned role"
    user.should_not be_in_role(role)
  endend

