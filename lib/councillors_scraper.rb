class CouncillorsScraper

	def initialize
		@base_uri             = "http://www1.toronto.ca"
		@councillor_list_path = "/wps/portal/contentonly?vgnextoid=c3a83293dc3ef310VgnVCM10000071d60f89RCRD"
		@councillors = []
	end

	def get(uri)
		HTTP.with_headers( "Accept-Charset" => "utf-8" )
				.get(uri)
				.body
				.to_s
	end

	def councillors_paths
		uri = URI(@base_uri + @councillor_list_path)
		Loofah.document( get(uri) )
			.scrub!(:strip)
			.xpath('//table')
			.css("a")
			.map {|a| a.attr( "href" ) if a.text.include?( "Councillor" )} #|| a.text.include?( "Mayor" ) }
			.compact
	end

	def councillor_info
		puts "Getting Councillor Info"
		councillors_paths.each do |path|
			print " 🚀 "
			hash = {}
			uri = URI(@base_uri + path)
			doc = Loofah.document( get(uri) ).scrub!(:strip)
			hash[:name] = doc.css("h1").text.strip
			hash[:image] = doc.css("table").css("img").attr("src")
			@councillors << hash
		end
	end


	def run
		councillor_info
	end
end

