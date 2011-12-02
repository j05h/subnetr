require 'minitest/spec'
require 'minitest/autorun'
require 'lib/subnetr'

describe Subnetr do

  before do
    @s       = Subnetr::Calc.new
  end

  describe "slash 32" do
    before do
      @s = Subnetr::Calc.new "192.168.0.1/32"
    end

    it "has a valid binary subnet mask" do
      @s.binary_netmask.must_equal '11111111.11111111.11111111.11111111'
    end

    it "has a valid subnet mask" do
      @s.netmask.must_equal '255.255.255.255'
    end

    it "has a valid number of hosts" do
      @s.hosts.must_equal 1
    end

    it "has a starting ip" do
      @s.ip_address.must_equal "192.168.0.1"
    end

    it "has a proper ip range" do
      @s.ip_range.must_equal ["192.168.0.1"]
    end
  end

  describe "slash 30" do
    before do
      @s = Subnetr::Calc.new "192.168.0.1/30"
    end

    it "has a valid binary subnet mask" do
      @s.binary_netmask.must_equal '11111111.11111111.11111111.11111100'
    end

    it "has a valid subnet mask" do
      @s.netmask.must_equal '255.255.255.252'
    end

    it "has a valid number of hosts" do
      @s.hosts.must_equal 2
    end

    it "has a starting ip" do
      @s.ip_address.must_equal "192.168.0.1"
    end

    it "has a proper ip range" do
      @s.ip_range.must_equal ["192.168.0.1", "192.168.0.2"]
    end
  end

  describe "slash 28" do
    before do
      @s = Subnetr::Calc.new "192.168.0.1/28"
    end

    it "has a valid binary subnet mask" do
      @s.binary_netmask.must_equal '11111111.11111111.11111111.11110000'
    end

    it "has a valid binary wildcard" do
      @s.binary_wildcard.must_equal '00000000.00000000.00000000.00001111'
    end

    it "has a valid wildcard" do
      @s.wildcard.must_equal '0.0.0.15'
    end

    it "has a valid subnet mask" do
      @s.netmask.must_equal '255.255.255.240'
    end

    it "has a valid number of hosts" do
      @s.hosts.must_equal 14
    end

    it "has a starting ip" do
      @s.ip_address.must_equal "192.168.0.1"
    end

    it "has a proper ip range" do
      @s.ip_range.must_equal [
        "192.168.0.1" , "192.168.0.2"  , "192.168.0.3" , "192.168.0.4" ,
        "192.168.0.5" , "192.168.0.6"  , "192.168.0.7" , "192.168.0.8" ,
        "192.168.0.9" , "192.168.0.10" , "192.168.0.11", "192.168.0.12",
        "192.168.0.13", "192.168.0.14"
      ]
    end
  end

  describe "calculations" do
    it "can create a calc class" do
      @s.wont_be_nil
    end

    it "must raise an exception on bad cidr" do
      lambda do
        @s.cidr_to_netmask('/33')
      end.must_raise(Subnetr::InvalidCIDRException)

      lambda do
        @s.cidr_to_netmask('/0')
      end.must_raise(Subnetr::InvalidCIDRException)
    end

    it "can convert /32 to subnet mask" do
      @s.cidr_to_netmask('/32').must_equal '255.255.255.255'
    end

    it "can convert /30 to subnet mask" do
      @s.cidr_to_netmask('192.168.0.1/30').must_equal '255.255.255.252'
    end

    it "can convert /24 to subnet mask" do
      @s.cidr_to_netmask('/24').must_equal '255.255.255.0'
    end

    it "can convert /8 to subnet mask" do
      @s.cidr_to_netmask('/8').must_equal '255.0.0.0'
    end

    it "can convert /32 to binary" do
      @s.cidr_to_binary('/32').must_equal '11111111.11111111.11111111.11111111'
    end

    it "can convert /30 to binary" do
      @s.cidr_to_binary('/30').must_equal '11111111.11111111.11111111.11111100'
    end

    it "can convert /30 to wildcard" do
      @s.cidr_to_wildcard('/30').must_equal '00000000.00000000.00000000.00000011'
    end

    it "can convert /8 to binary" do
      @s.cidr_to_binary('/8').must_equal '11111111.00000000.00000000.00000000'
    end

    it "can convert /8 to wildcard" do
      @s.cidr_to_wildcard('/8').must_equal '00000000.11111111.11111111.11111111'
    end

    it "can convert /32 to hosts" do
      @s.cidr_to_hosts('/32').must_equal 1
    end

    it "can convert /30 to hosts" do
      @s.cidr_to_hosts('192.168.0.1/30').must_equal 2
    end

    it "can convert /24 hosts" do
      @s.cidr_to_hosts('/24').must_equal 254
    end

    it "can convert /8 hosts" do
      @s.cidr_to_hosts('/8').must_equal 16777214
    end
  end
end
