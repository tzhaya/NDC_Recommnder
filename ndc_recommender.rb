require "metainspector"
require "net/http"
require "json"
require 'optparse'
require 'csv'

class AppOption
  require 'optparse'

  # インスタンス化と同時にコマンドライン引数をパース
  def initialize
    @options = {}
    OptionParser.new do |o|
    #  o.on('-c', '--csv', 'output csv') { |v| @options[:csv] = v }
    #  o.on('-v', '--verpose', 'output verpose') { |v| @options[:verpose] = v }
      o.on('-u', '--uri item', 'set URI') { |v| @options[:uri] = v }
      o.on('-h', '--help', 'show this help') {|v| puts o; exit }
      o.parse!(ARGV)
    end
  end

  # オプションが指定されたかどうか
  def has?(name)
    @options.include?(name)
  end

  # オプションごとのパラメータを取得
  def get(name)
    @options[name]
  end

  # オプションパース後に残った部分を取得
  def get_extras
    ARGV
  end
end



# URIをコマンドの引数で指定
# uri = ARGV[0]

option = AppOption.new
if option.has?(:uri)
  uri = option.get(:uri)   # --add オプションのパラメータを取得
  #uri = option.get_extras
end

# 指定されたWebページの内容を取得
page = MetaInspector.new(uri)

puts "ページタイトル:\r\n" + page.title
puts "Description:\r\n" + page.description

if page.description != "" then
# NDCpredicterのAPIにttleとdescriptionをPOSTで送信
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
