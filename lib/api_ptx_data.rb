require 'uri'
require 'net/http'
require 'openssl'
require 'base64'
require 'ostruct'
require 'json'
require 'zlib'

class ApiPtxData
  def initialize(app_id: 'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF', app_key: 'FFFFFFFF-FFFF-FFFF-FFFF-FFFFFFFFFFFF')
    @app_id = app_id
    @app_key = app_key
    @estimate_time = nil
  end

  def is_bus_arriving?
    po_jen_info = get_po_jen_info
    if po_jen_info.nil? || po_jen_info['EstimateTime'].blank?
      false
    else
      @estimate_time = po_jen_info['EstimateTime'].to_i
      @estimate_time <= 10.minutes
    end
  end

  private

  def get_po_jen_info
    get_response(
      uri: "https://ptx.transportdata.tw/MOTC/v2/Bus/EstimatedTimeOfArrival/City/Taipei/672?$filter=Direction%20eq%20'1'%20and%20StopUID%20eq%20'TPE38909'&$format=JSON",
      gzip: true
    )&.first
  end

  def get_response(uri:, gzip: false, options: {})
    uri_parser = URI.parse(uri)
    timestamp = get_gmt_timestamp
    hmac = encode_by_hmac_sha1(@app_key, 'x-date: ' + timestamp)

    request = Net::HTTP::Get.new(uri_parser)
    request['Accept'] = 'application/json'
    request['Accept-Encoding'] = 'gzip' if gzip
    request['X-Date'] = timestamp
    request['Authorization'] = %Q(hmac username=\"#{@app_id}\", algorithm=\"hmac-sha1\", headers=\"x-date\", signature=\"#{hmac}\")

    req_options = {
      use_ssl: uri_parser.scheme == 'https',
    }.merge(options)

    response = Net::HTTP.start(uri_parser.hostname, uri_parser.port, req_options) do |http|
      http.request(request)
    end

    parse_json_response(response)
  end

  def get_gmt_timestamp
    Time.now.utc.strftime('%a, %d %b %Y %T GMT')
  end

  def encode_by_hmac_sha1(key, value)
    Base64.encode64(
      OpenSSL::HMAC.digest(
        OpenSSL::Digest.new('sha1'),
        key,
        value,
      )
    ).strip()
  end

  def parse_json_response(response)
    response_body = case response.header['content-encoding']
    when 'gzip'
      sio = StringIO.new(response.body)
      gz = Zlib::GzipReader.new(sio)
      gz.read()
    else
      response.body
    end

    JSON.parse(response_body.force_encoding('UTF-8'))
  rescue => e
    puts "parse json response error!, #{e}"
    nil
  end
end
