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
		councillors_paths.each_with_index do |path, i|
			if i % 15 == 0
				print "Sleeping... 💆\n"
				sleep(2)
			end
			print " 🚀 "
			hash = {}
			uri = URI(@base_uri + path)
			puts uri
			doc = Loofah.document( get(uri) ).scrub!(:strip)
			@councillors << { name:  get_name(doc),
				image: get_img_src(doc),
				website: get_website(doc)
			}
		end
	end

	def get_name(doc)
		doc.css("h1").text.strip
	end

	def get_img_src(doc)
		doc.css("table").css("img").attr("src")
	end
	
	def get_website(doc)
		href = doc.xpath('//table/tbody/tr[1]/td[1]').css("a").first.attr("href")
		href unless href =~ /([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)/ #regex for an email address
	end


	def run
		councillor_info
		puts @councillors
	end
end

