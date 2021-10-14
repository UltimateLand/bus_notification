require_relative '../lib/api_ptx_data'

ptx_data = ApiPtxData.new
NotificationMailer.send_mail(ptx_data.estimate_time).deliver if ptx_data.is_bus_arriving?
