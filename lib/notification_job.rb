class NotificationJob
  def self.run
    ptx_data = Crawler::ApiPtxData.new
    NotificationMailer.send_mail(ptx_data.estimate_time).deliver if ptx_data.is_bus_arriving?
  end
end
