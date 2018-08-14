

def match_example(match_str)
    regexp = Regexp.new(match_str,Regexp::MULTILINE)
    result = regexp.match(MESSAGE)
    if result
        result.captures.first
    else
        nil
    end
end

def scan_example(match_str)
    regexp = Regexp.new(match_str,Regexp::MULTILINE)
    result = MESSAGE.scan(regexp).flatten
end

if __FILE__ == $0
    require 'minitest/autorun'
    require 'minitest/spec'
    require 'testhelper'

    MESSAGE = %Q{
        ELBC: svcgrp_id=1, chassis=1, slot_id=1

        zone: self_idx:1, master_idx:1, members:4
        FIM10E3E16000078, Master, uptime=165768.65, priority=1, slot_id=1:1, idx=1, flag=0, in_sync=1
        FIM10E3E16000069, Slave, uptime=165776.44, priority=2, slot_id=1:2, idx=0, flag=0, in_sync=1
            elbc-base-ctrl: state=3(connected), ip=169.254.1.16, last_hb_time=165898.57, hb_nr=792752
        FPM20E3E16800029, Slave, uptime=165761.31, priority=20, slot_id=1:4, idx=2, flag=4, in_sync=1
            elbc-base-ctrl: state=3(connected), ip=169.254.1.4, last_hb_time=165898.53, hb_nr=792710
        FPM20E3E16800033, Slave, uptime=165763.98, priority=19, slot_id=1:3, idx=3, flag=4, in_sync=1
            elbc-base-ctrl: state=3(connected), ip=169.254.1.3, last_hb_time=165898.57, hb_nr=792759
    }

    describe "regexp" do
        it "match_example" do
            match_example('Master,.+?slot_id=(\d+:\d+)').must_equal(
                    "1:1")
        end
        it "scan_example" do
            scan_example('Slave,.+?slot_id=(\d+:\d+)').must_equal(
                    ["1:2", "1:4", "1:3"])
            scan_example('111,.+?slot_id=(\d+:\d+)').must_equal(
                    [])
        end
    end
end
