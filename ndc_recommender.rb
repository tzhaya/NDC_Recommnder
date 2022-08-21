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
      o.on('-i VALUE',   'input file name') { |v| @options[:inputfilename] = v }
      o.on('-t',         'add title to predict') { |v| @options[:title] = v }
      o.on('-o [VALUE]', 'output CSV file name') { |v| @options[:outfilename] = v ; }
      o.on('-u VALUE',   'set URI') { |v| @options[:uri] = v }
      o.on('-h',         'show this help') {|v| puts o; exit }
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

option = AppOption.new

if option.has?(:uri)
  uri = option.get(:uri)
  if URI.regexp.match(uri).nil?
    puts "You must set URI. usage: -u [URI]."
    exit
  end
else
  if option.has?(:inputfilename) 
  then

  else
    puts "You must set URI. usage: -u [URI]."
    exit
end

# CSVで出力

if option.has?(:outfilename)
  outfilename   = option.get(:outfilename)
  inputfilename = option.get(:inputfilename)
    if 
      outfilename.nil? 
      then 
        outfilename = "outfile.csv"
    end
    CSV.open(outfilename,'w') do |csv|
      csv << ["URL","Title","Description","NDC 1","NDC 1 Label","NDC 1 score","NDC 2","NDC 2 label","NDC 2 score","NDC 3","NDC 3 label","NDC 3 score"]        ##ヘッダ
    
    File.foreach(inputfilename){|uri|
      page = MetaInspector.new(uri)
      if page.description != "" then
        param = page.description
          else
            param = page.title    
      end
      res = Net::HTTP.post_form(URI.parse('https://lab.ndl.go.jp/ndc/api/predict'),{ 'bib' => param })
      result = JSON.parse(res.body)

      csv << [uri, page.title, page.description,
              "#{result[0]["value"]}","#{result[0]["label"]}","#{result[0]["score"]}",
              "#{result[1]["value"]}","#{result[1]["label"]}","#{result[1]["score"]}",
              "#{result[2]["value"]}","#{result[2]["label"]}","#{result[2]["score"]}"]
      }
      sleep 1
      end

    exit
end

# 指定されたWebページの内容を取得
page = MetaInspector.new(uri)

puts "ページタイトル:\r\n" + page.title
puts "Description:\r\n" + page.description

if page.description != "" then
# -t でタイトルを加える指定があればtitleとdescription、なければdescritionのみをNDCpredicterのAPIにPOSTで送信
  if option.has?(:title)  then
    param = page.title + page.description
    else
    param = page.description
  end
  res = Net::HTTP.post_form(URI.parse('https://lab.ndl.go.jp/ndc/api/predict'),{ 'bib' => param })
  else
  puts "No description."
end

# 結果がJSONで返ってくるのでparse
  result = JSON.parse(res.body)
  puts ""
  puts "NDC predicter による候補："
  puts "#{result[0]["value"]} / #{result[0]["label"]}"
  puts "#{result[1]["value"]} / #{result[1]["label"]}"
  puts "#{result[2]["value"]} / #{result[2]["label"]}"
end
