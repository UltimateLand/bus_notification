require "test_helper"

class NotificationMailerTest < ActionMailer::TestCase
  test "send_mail" do
    mail = NotificationMailer.send_mail
    assert_equal "Send mail", mail.subject
    assert_equal ["to@example.org"], mail.to
    assert_equal ["from@example.com"], mail.from
    assert_match "Hi", mail.body.encoded
  end

end
