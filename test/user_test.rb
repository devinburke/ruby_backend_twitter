require 'test_helper'

class Minitest::Spec
  @@password = 'test'
  @@user = User.create(
    email: 'test email',
    username: 'test username',
    password: @@password,
    password_confirmation: @@password
  )

  def self.allow_sign_in(method, user, attribute, password)
    it "should allow sign in with #{attribute} and password" do
      User.method(method).call(user[attribute], password).must_equal user
    end

    it "should return nil given wrong #{attribute}" do
      assert_nil User.method(method).call('wrong', password)
    end

    it "should return nil given wrong password" do
      User.method(method).call(user[attribute], 'wrong').must_equal false
    end
  end

  describe User do
    describe "#subscribe_to_hashtag" do  
      it "should return a hashtag if one already exists" do
        hashtag = Hashtag.create(tag: SecureRandom.hex)

        subscription = Subscription.create(user: @@user, hashtag: hashtag)

        assert_equal(@@user.subscribe_to_hashtag(hashtag), subscription)
      end

      it "should return a newly created subscription" do
        assert(@@user.subscribe_to_hashtag(Hashtag.create(tag: SecureRandom.hex)).instance_of? Subscription)
      end
    end

    describe "#save" do
      it "should save password_digest as a bcrypt hash" do
        assert @@user.password_digest.match(/^\$2[ayb]\$.{56}$/)
      end
    end

    describe '#sign_in_with_email' do
      allow_sign_in('sign_in_with_email', @@user, 'email', @@password)
    end

    describe '#sign_in_with_username' do
      allow_sign_in('sign_in_with_username', @@user, 'username', @@password)
    end

    describe "Validations" do
      before do
        @user = User.new(
          email: 'test email',
          username: 'test username',
          password: @@password,
          password_confirmation: @@password)

        assert @user.valid?
      end

      describe "#password" do
        it "should validate password presence" do
          @user.password = nil

          refute @user.valid?
          assert_equal(@user.errors[:password].first, "can't be blank")
        end
      end

      describe "#password_confirmation" do
       it "should validate password and password_confirmation are the same" do
          @user.password_confirmation = "wrong"

          refute @user.valid?
          assert_equal(@user.errors[:password_confirmation].first, "doesn't match Password")
        end
      end

      describe "#email #username" do
        it "should validate email and username if both are empty" do
          @user.username = nil
          @user.email = nil

          refute @user.valid?
          assert_equal(@user.errors[:email].first, "can't be blank")
          assert_equal(@user.errors[:username].first, "can't be blank")
        end

        it "should be valid with only email" do
          @user.username = nil

          assert @user.valid?
        end

        it "should be valid with only username" do
          @user.email = nil

          assert @user.valid?
        end
      end
    end
  end
end
