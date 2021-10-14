class Receiver < ActiveRecord::Base
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }, uniqueness: true

  def self.register(email)
    create!(email: email)
    p "#{email} have been registered!"
  rescue => e
    p e.message
  end
end
