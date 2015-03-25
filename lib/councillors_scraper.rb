class CouncillorsScraper

	def initialize
		@base_uri             = "http://www1.toronto.ca"
		@councillor_list_path = "/wps/portal/contentonly?vgnextoid=c3a83293dc3ef310VgnVCM10000071d60f89RCRD"
		@councillors          = []
		@names = []
	end

	def get(uri)
		HTTP.with_headers( "Accept-Charset" => "utf-8" )
				.get(uri)
				.body
				.to_s
	end

	def councillors_table
		uri = URI(@base_uri + @councillor_list_path)
		Loofah.document( get(uri) )
			.scrub!(:strip)
			.xpath('//table')
	end

	def councillors_paths
		councillors_table.css("a")
			.map {|a| a.attr( "href" ) if a.text.include?( "Councillor" )} #|| a.text.include?( "Mayor" ) }
			.compact
	end

	def councillor_info
		puts "Getting Councillor Info"
		councillors_paths.each_with_index do |path, i|
			if i > 0 && i % 15 == 0
				print " Sleeping... 💆 Zzzz "
				sleep(2)
			end
			print " 🚀 "
			hash = {}
			uri = URI(@base_uri + path)
			doc = Loofah.document( get(uri) ).scrub!(:strip)
			@councillors << { name:  "hi",
				image: @base_uri + get_img_src(doc),
				website: get_website(doc)
			}
		end
	end

	def get_name(doc)
		cells = doc.xpath('//table').css("tr").map do |tr|
			tr.css("td").map do |td|
				td.children.text
			end
		end.flatten.delete_if { |cell| cell.length < 2 }
		cells[1..44].each do |cell|
			@names << cell.split(" - ")[0].split(", ")
		end
	end
# def get_name(doc)
# 		doc.css("h1").text.strip.split(" ")
# 	end

	def get_img_src(doc)
		doc.css("table").css("img").attr("src").to_s
	end
	
	def get_website(doc)
		href = doc.xpath('//table/tbody/tr[1]/td[1]').css("a").first.attr("href")
		href unless href =~ /([\w\.\-]+)@([\w\-]+)((\.(\w){2,3})+)/ #regex for an email address
	end

	def run
# def get_name(doc)
		councillor_info
		doc = councillors_table
		binding.pry
	end
end

