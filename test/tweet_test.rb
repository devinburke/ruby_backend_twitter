require 'test_helper'

class Minitest::Spec
  describe Tweet do
    describe "#after_create" do
      it "create hashtags for ones that do not exist" do
        hash1 = SecureRandom.hex
        hash2 = SecureRandom.hex
        count = Hashtag.count
        
        Tweet.create(content: "##{hash1} and ##{hash2}")

        assert_equal(count + 2, Hashtag.count)
      end
      it "does not create hashtags for existing ones" do
        hash1 = SecureRandom.hex
        count = Hashtag.count
        
        Tweet.create(content: "##{hash1} and ##{hash1}")

        assert_equal(count + 1, Hashtag.count)
      end

      it "calls notify on all hashtags in content" do
        hashtag_mock = mock()
        hashtag_mock.expects(:notify_users).twice

        Hashtag.stubs(:find_or_create_by).returns(hashtag_mock)

        hash1 = SecureRandom.hex
        hash2 = SecureRandom.hex

        Tweet.create(content: "##{hash1} and ##{hash2}")
      end
    end

    describe "Validations" do
      before do
        @tweet = Tweet.new(content: 'test')

        assert @tweet.valid?
      end

      describe "#content" do
        it "should validate content length is 140 characters or less" do
          @tweet.content = "0" * 141         

          refute @tweet.valid?
          assert_equal(@tweet.errors[:content].first, "is too long (maximum is 140 characters)")
        end
      end
    end
  end
end
