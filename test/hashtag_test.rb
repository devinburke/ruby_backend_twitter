require 'test_helper'

class Minitest::Spec
  describe Hashtag do
    describe "#notify_users" do
      it "should call notify on all subscription users" do
        users = 2.times.collect { User.create(email: 'test', password: 'test', password_confirmation: 'test') }
        hashtag = Hashtag.create(tag: SecureRandom.hex)

        user_mock = mock()
        user_mock.expects(:notify).times(users.count)

        Subscription.any_instance.stubs(:user).returns(user_mock)

        users.each { |user| Subscription.create(user: user, hashtag: hashtag) }
        
        hashtag.notify_users
      end
    end

    describe "Validations" do
      before do
        @hashtag = Hashtag.new(tag: SecureRandom.hex)

        assert @hashtag.valid?
      end

      describe "#tag" do
        it "should validate tag uniqueness" do
          Hashtag.create(tag: @hashtag.tag)          

          refute @hashtag.valid?
        end
      end
    end
  end
end
