require "metainspector"
require "net/http"
require "json"

# URIをコマンドの引数で指定
uri = ARGV[0]

# 指定されたWebページの内容を取得
page = MetaInspector.new(uri)

puts "ページタイトル:\r\n" + page.title
puts "Description:\r\n" + page.description

if page.description != "" then
# NDCpredicterのAPIにtitleとdescriptionをPOSTで送信
  res = Net::HTTP.post_form(URI.parse('https://lab.ndl.go.jp/ndc/api/predict'),{'bib' => page.title + page.description})
# 結果がJSONで返ってくるのでparse
  result = JSON.parse(res.body)
  puts ""
  puts "NDC predicter による候補："
  puts "#{result[0]["value"]} / #{result[0]["label"]}"
  puts "#{result[1]["value"]} / #{result[1]["label"]}"
  puts "#{result[2]["value"]} / #{result[2]["label"]}"
 else
  puts "No description"
end
