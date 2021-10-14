class NotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notification_mailer.send_mail.subject
  #
  def send_mail(countdown_sec)
    @countdown_min = countdown_sec / 60

    receivers = Receiver.pluck(:email).join(',')
    mail(to: receivers, subject: 'Bus No.672 is arriving') if receivers.present?
  end
end
