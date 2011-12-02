require 'minitest/spec'
require 'minitest/autorun'
require 'lib/subnetr'

describe Subnetr do
  before do
    @s = Subnetr::Calc.new
  end

  def must_cidr_to_binary cidr, binary
      @s.cidr_to_binary("/#{cidr}").must_equal binary
      @s.cidr_to_binary(cidr).must_equal binary
  end

  describe "calculations" do
    it "can create a calc class" do
      @s.wont_be_nil
    end

    it "can convert /32 cider to subnet mask" do
      @s.cidr_to_netmask('/32').must_equal '255.255.255.255'
    end

    it "can convert /30 cider to subnet mask" do
      @s.cidr_to_netmask('/30').must_equal '255.255.255.252'
    end

    it "can convert /24 cider to subnet mask" do
      @s.cidr_to_netmask('/24').must_equal '255.255.255.0'
    end

    it "can convert /8 cider to subnet mask" do
      @s.cidr_to_netmask('/8').must_equal '255.0.0.0'
    end

    it "can convert /32 cider to binary" do
      must_cidr_to_binary 32, '11111111.11111111.11111111.11111111'
    end

    it "can convert /30 cider to binary" do
      must_cidr_to_binary 30, '11111111.11111111.11111111.11111100'
    end

    it "can convert /8 cider to binary" do
      must_cidr_to_binary 8, '11111111.00000000.00000000.00000000'
    end

    it "can convert /7 cider to binary" do
      must_cidr_to_binary 7, '11111111.00000000.00000000.00000000'
    end

    it "can convert /1 cider to binary" do
      must_cidr_to_binary 1, '11111111.00000000.00000000.00000000'
    end

    it "can convert /32 to hosts" do
      @s.cidr_to_hosts('/32').must_equal 1
    end

    it "can convert /30 to hosts" do
      @s.cidr_to_hosts('/30').must_equal 2
    end

    it "can convert /24 hosts" do
      @s.cidr_to_hosts('/24').must_equal 254
    end

    it "can convert /8 hosts" do
      @s.cidr_to_hosts('/8').must_equal 16777214
    end
  end
end
