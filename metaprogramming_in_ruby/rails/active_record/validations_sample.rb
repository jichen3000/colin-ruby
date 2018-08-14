require 'active_model' 

class User
    include ActiveModel::Validations
    attr_accessor :password
    validate do
        errors.add(:base, "Don't let dad choose the password.") if password == '1234'
    end 
end


if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    describe "some" do
        it "function" do
            user = User.new
            user.password = "123456"
            user.valid?.must_equal(true)
            user.password = "1234"
            user.valid?.must_equal(false)
        end
    end
end