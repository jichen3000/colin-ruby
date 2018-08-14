from scapy.all import *

if __name__ == '__main__':
    from minitest import *

    with test(send):
        # you must run it using root
        send(IP(dst="10.160.13.112")/ICMP()/"HelloWorld")
        send(IP(src="10.160.13.1", dst="10.160.13.112")/ICMP()/"HelloWorld")
        send(IP(src="10.160.13.1", dst="10.160.13.112", ttl=128)/ICMP(type=0)/"HelloWorld")
        pass

    with test(sr):
        h1=sr1(IP(dst="10.160.13.112")/ICMP())
        h=sr(IP(dst="10.160.13.112")/ICMP())

        p=sr(IP(dst="10.160.13.112")/TCP(dport=23)) # 23 is telnet port
        p=sr(IP(dst="10.160.13.112")/TCP(dport=[22,23,80,53])) # 23 is telnet port
        p=sr(IP(dst="10.160.13.112")/TCP(dport=[23,80,53])) # 23 is telnet port

        p=sr1(IP(dst="10.160.13.112")/TCP(sport=666,dport=[22,80,21,443], flags="S"))
        p=sr(IP(dst="10.160.13.112")/TCP(sport=888,dport=[22,80,21,443], flags="A"))
        p=sr(IP(src="10.160.13.1", dst="10.160.13.112")/TCP(sport=RandShort(), dport=[20,21,80,3389]),inter=0.5,retry=2,timeout=1)

        p = sr1(IP(dst="10.160.13.112")/UDP()/DNS(rd=1,qd=DNSQR(qname="www.citrix.com")))
        p = sr1(IP(dst="8.8.8.8")/UDP()/DNS(rd=1,qd=DNSQR(qname="www.citrix.com")))
        p = sr1(IP(dst="8.8.8.8")/UDP()/DNS(rd=1,qd=DNSQR(qname="citrix.com",qtype= "NS")))

        ans,unans=sr(IP(dst="10.160.13.112")/TCP(dport=[80,666]))

        # IP Scan
        ans,unans=sr(IP(dst="10.160.13.112",proto=(0,255))/"SCAPY",retry=2)

        # show all the addresses which have been occupied.
        ans,unans=arping("10.160.13.*")
        ans,unans=arping("172.30.184.*")

        # ICMP ping not working
        # WARNING: Mac address to reach destination not found. Using broadcast
        ans,unans=sr(IP(dst="172.30.184.1-254")/ICMP())
        ans,unans=sr(IP(dst="10.160.13.1-254")/ICMP())

        # TCP ping not working
        # WARNING: Mac address to reach destination not found. Using broadcast
        ans,unans=sr( IP(dst=”10.1.99.*”)/TCP(dport=80, flags=”S”) )

        # UDP ping not working
        # WARNING: Mac address to reach destination not found. Using broadcast
        ans,unans=sr( IP(dst="10.1.99.*"/UDP(dport=0) )
        pass

    with test(traceroute):
        t = traceroute(["www.google.com"], maxttl=20)
        t = traceroute(["10.160.13.1"], maxttl=20)
        t = traceroute(["10.160.13.1"],dport=23, maxttl=20)
        t = traceroute(["10.160.13.1","www.google.com","www.citrix.com"], maxttl=20)

    with test(sniff):
        s = sniff()
        s.show()
        sniff(iface="en0",count=3, filter="tcp")
        sniff(filter="icmp and host 66.35.250.151", count=2)
        s=_
        pass

    with test("pcap"):
        p = rdpcap("/Users/colin/tmp/tmp.pcap")
        sniff(filter="icmp and host 66.35.250.151", count=2)
        s=_
        wrpcap("/Users/colin/tmp/tmp.pcap", s)
        # replay
        for pkt in p: send(pkt)

    with test("more"):
        send(IP(dst="10.160.13.1")/fuzz(UDP()/NTP(version=4)),loop=1)


