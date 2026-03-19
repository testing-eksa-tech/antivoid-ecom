require 'net/http'
require 'uri'
require 'json'
require 'base64'

module XenditHelper
  XENDIT_URL = 'https://api.xendit.co/v2/invoices'

  def self.create_invoice(order)
    secret_key = ENV['XENDIT_SECRET_KEY']
    return nil unless secret_key

    uri = URI.parse(XENDIT_URL)
    request = Net::HTTP::Post.new(uri)
    
    # Basic Auth
    auth = Base64.strict_encode64("#{secret_key}:")
    request["Authorization"] = "Basic #{auth}"
    request["Content-Type"] = "application/json"
    
    body = {
      external_id: order.id.to_s,
      amount: order.total_price.to_i,
      payer_email: order.customer_email,
      description: "Order ##{order.id} from Antivoid Shop",
      success_redirect_url: "#{ENV['BASE_URL'] || 'http://localhost:9292'}/order-success?id=#{order.id}",
      failure_redirect_url: "#{ENV['BASE_URL'] || 'http://localhost:9292'}/cart"
    }
    
    request.body = body.to_json

    response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
      http.request(request)
    end

    if response.code == '200' || response.code == '201'
      JSON.parse(response.body)
    else
      puts "Xendit Error: #{response.code} - #{response.body}"
      nil
    end
  rescue => e
    puts "Xendit Exception: #{e.message}"
    nil
  end

  def self.verify_callback(token)
    token == ENV['XENDIT_CALLBACK_TOKEN']
  end
end
