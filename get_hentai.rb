require 'mechanize'
require 'nokogiri'

agent=Mechanize.new

#画像のあるページの１ページ目から順に取得していく。
page=agent.get("http://g.e-hentai.org/s/sample-page/sample-page-1")
#タイトル名を取得
filename=page.search("h1").children.text


#取得したタイトル名のフォルダを新規作成し、取得した画像はここに保存する。
Dir.mkdir("./#{filename}",0777)
Dir.chdir("./#{filename}")

link_lists=[]
#画像の最終ページに行き着くまでループを回し、全ての画像URLを取得する。
link_lists << page
loop do
	
	next_url=page.link_with(:id=>"next").href
	page=page.link_with(:id=>"next").click

	link_lists << page
	next_next=page.link_with(:id=>"next").href
#最終ページまで行ったら終わり。
break if next_url==next_next

end

#取得したページをまわして、画像を取得する。
retry_counter=0
link_lists.each do |page|
begin
	page.image_with(:id=>"img").fetch.save
rescue
	if retry_counter < 5
	retry_counter+=1
	puts "画像の取得に失敗しました。リトライします。#{retry_counter}回目"
		sleep(5)
		redo
	else
	puts "画像の取得を諦めました。次の画像を取得します"
		retry_counter=0
		next
	end	
end
end



