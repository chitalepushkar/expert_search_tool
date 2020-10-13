require 'nokogiri'
require 'open-uri'

class HeaderScraper
	def self.save_user_headings(user_id)
		user = User.find(user_id)
		return unless user.present?
		return unless user.web_url.present?

		uri = URI(user.web_url)
		if uri.instance_of?(URI::Generic)
		  uri = URI::HTTP.build({:host => uri.to_s})
		end

	  doc = Nokogiri::HTML(open(uri))
	  return unless doc.present?
	  doc.xpath('//h1', '//h2', '//h3').collect(&:text).each do |heading|
	  	ExpertTopic.create(user_id: user.id, topic: heading.squish) if heading.present?
	  end
  rescue StandardError => e
  	print e
	end
end
