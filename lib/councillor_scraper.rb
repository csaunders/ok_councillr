class CouncillorScraper

	def initialize
		@base_uri             = "http://www1.toronto.ca"
		@councillor_list_path = "/wps/portal/contentonly?vgnextoid=c3a83293dc3ef310VgnVCM10000071d60f89RCRD"
	end


	def request(uri)
		Net::HTTP::Get.new(uri).add_field( "Accept-Charset", "utf-8")
	end

	def response_body(uri)
		Net::HTTP.start(uri.hostname, uri.port) {|http|
			http.request(request(uri)).body
		}
	end

	def councillors_paths
		uri = URI(@base_uri + @councillor_list_path)
		Loofah.document(response_body(uri))
			.scrub(:strip)
			.xpath('//table')
			.css("a")
			.map {|a| a.attr("href") unless a.text.include? "Ward" }
			.compact
	end
end

