class WebUrlShortener
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(user_id)
    user = User.find(user_id)
    return unless user.present?
    return unless user.web_url.present?

	uri = URI(user.web_url)
	if uri.instance_of?(URI::Generic)
	  uri = URI::HTTP.build({:host => uri.to_s})
	end

    client = Bitly::API::Client.new(token: ENV['BITLY_TOKEN'])
    bitlink = client.shorten(long_url: uri)
    user.update(short_url: bitlink.link) if bitlink.present?
  end
end