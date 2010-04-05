require 'test_helper'

class ShareMailerTest < ActionMailer::TestCase
  test "notify" do
    @expected.subject = 'ShareMailer#notify'
    @expected.body    = read_fixture('notify')
    @expected.date    = Time.now

    assert_equal @expected.encoded, ShareMailer.create_notify(@expected.date).encoded
  end

end
