uri                       = URI("http://www1.toronto.ca/wps/portal/contentonly?vgnextoid=c3a83293dc3ef310VgnVCM10000071d60f89RCRD")
request                   = Net::HTTP::Get.new(uri)
request['Accept-Charset'] = "utf-8"

response = Net::HTTP.start(uri.hostname, uri.port) {|http|
	http.request(request)
}

doc = Loofah.document(response.body).scrub! :strip

table = doc.xpath('//table')

urls = table.css("a").map {|a| a.attr("href") unless a.text.include? "Ward" }.compact