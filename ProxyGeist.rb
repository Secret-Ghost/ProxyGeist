require 'capybara/poltergeist'
require 'rubygems'
require 'net/ping'
require 'socksify/http'
require 'nokogiri'
require 'colorize'

session = Capybara::Session.new(:poltergeist)


$i =  0
$num = ARGV[0].to_i
$timeout = ARGV[1].to_i

threads = []
out_file = File.new('out.txt', "w")

def icanhazconnect?(proxy)
  host, port = proxy.split(':')
  return Net::Ping::TCP.new(host, port, $timeout).ping
end


puts'                      :::!~!!!!!:.'
puts'                  .xUHWH!! !!?M88WHX:.'
puts'                .X*#M@$!!  !X!M$$$$$$WWx:.'
puts'               :!!!!!!?H! :!$!$$$$$$$$$$8X:'
puts'              !!~  ~:~!! :~!$!#$$$$$$$$$$8X:'
puts'             :!~::!H!<   ~.U$X!?R$$$$$$$$MM!'
puts'             ~!~!!!!~~ .:XW$$$U!!?$$$$$$RMM!'
puts'               !:~~~ .:!M"T#$$$$WX??#MRRMMM!'
puts'               ~?WuxiW*`   `"#$$$$8!!!!??!!!'
puts'             :X- M$$$$       `"T#$T~!8$WUXU~'
puts'            :%`  ~#$$$m:        ~!~ ?$$$$$$'
puts'          :!`.-   ~T$$$$8xx.  .xWW- ~""##*"'
puts'.....   -~~:<` !    ~?T#$$@@W@*?$$      /`'
puts'W$@@M!!! .!~~ !!     .:XUW$W!~ `"~:    :'
puts'#"~~`.:x%`!!  !H:   !WM$$$$Ti.: .!WUn+!`'
puts':::~:!!`:X~ .: ?H.!u "$$$B$$$!W:U!T$$M~'
puts'.~~   :X@!.-~   ?@WTWo("*$$$W$TH$! `'
puts'Wi.~!X$?!-~    : ?$$$B$Wu("**$RM!'
puts'$R@i.~~ !     :   ~$$$$$B$$en:``'
puts'?MXT@Wx.~    :     ~"##*$$$$M~'
puts'Proxygeist by: Ghost @ vaughlive.tv'
puts 'Please wait, harvesting...'




until $i > $num  do

session.visit('http://spys.one/en/socks-proxy-list/' + $i.to_s + '/')
puts 'http://spys.one/en/socks-proxy-list/'.yellow + $i.to_s.yellow
         proxyandport = session.all(".spy14")#['innerText']
sleep 3
proxyandport.each do |item|

    sleep 0.1
    threads << Thread.new do
      if icanhazconnect?(item['innerText'].gsub(/\s+/, ''))
         #puts item['innerText'].gsub(/\s+/, '').split(':')
         proxy_addr, proxy_port = item['innerText'].gsub(/\s+/, '').split(':')

         begin

           http = Net::HTTP::SOCKSProxy(proxy_addr, proxy_port)
           html = http.get(URI('https://packetstormsecurity.com/'))
           html_doc = Nokogiri::HTML(html).to_s


           if html_doc.include? "Register"
               puts 'Yay!! icanhaz! ' + item['innerText'].gsub(/\s+/, "").green
               proxy = /[0-9]+(?:\.[0-9]+){3}:[0-9]+/.match(item['innerText'].gsub(/\s+/,''))
               out_file.puts( proxy)
           else
               puts 'dead :( ' + item['innerText'].gsub(/\s+/, "").red
           end

         rescue
           puts 'dead :( ' + item['innerText'].gsub(/\s+/, "").red
         end

      end

    end

end
$i +=1
threads.map(&:join)



end

out_file.close
puts 'Harvesting Finished. Have a nice day :)'



