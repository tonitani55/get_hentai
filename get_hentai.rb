require 'mechanize'
require 'nokogiri'
agent=Mechanize.new

page=agent.get("http://g.e-hentai.org/s/5591cb41ec/631426-1")
filename=page.search("h1").children.text
pp page



Dir.mkdir("./#{filename}",0777)
Dir.chdir("./#{filename}")
loop do
	begin
	page.images_with(:id=>"img").each do |img|
	img.fetch.save
	end
	rescue => e
	p e
	next
	end
	
	next_url=page.link_with(:id=>"next").href
	page=page.link_with(:id=>"next").click
	next_next=page.link_with(:id=>"next").href
	p next_url
	p next_next
	#saigo_url=page.links[4].href
break if next_url==next_next

end

