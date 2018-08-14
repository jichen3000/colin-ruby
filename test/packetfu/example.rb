# https://prezi.com/mw0_9qfb2d6d/packetfu-by-example/
# cd /Users/colin/.rvm/gems/ruby-2.1.2/gems/packetfu-1.1.10/examples
# rvmsudo irb -r ./packetfu-shell.rb

# run by pry
# rvmsudo pry 
require 'PcapRub'
require 'packetfu'
# rvmsudo irb -r ./packetfu-shell.rb
whoami? # PacketFu::Utils.whoami?
pkt=PacketFu::TCPPacket.new
pkt.ip_saddr = "172.30.184.96"
pkt.ip_daddr = "10.160.13.112"
pkt.tcp_sport = 1025
pkt.tcp_dport = 80
pkt.recalc;1

def sniff(iface=nil)
    iface ||="en0"
    cap = Capture.new(:iface=>iface, :start => true)
    cap.stream.each do |p|
        pkt = Packet.parse p
        if pkt.is_ip?
            next if pkt.ip_saddr == PacketFu::Utils.ifconfig(iface)[:ip_saddr]
            packet_info = [pkt.ip_saddr, pkt.ip_daddr, pkt.size, pkt.proto.last]
            puts "%-15s->%-15s-4d %s" % packet_info
        end
    end
end

p=PacketFu::IPPacket.new
p.ip_id = 0xbabe
p.ip_saddr = "172.30.184.96"
p.ip_daddr = "10.160.13.112"
p.payload = "Here's a pcaket"
p.recalc;1
3.times {p.to_w("en0")}

p=PacketFu::IPPacket.new
p.ip_id = 0xbabe
p.ip_saddr = "192.168.0.11"
p.ip_daddr = "192.168.0.1"
p.payload = "Here's a pcaket"
p.recalc;1
p.to_w("en0")