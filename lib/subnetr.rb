require "subnetr/version"

module Subnetr
  class Calc
    attr_reader :cidr, :ip_address, :ip_range, :hosts,
      :netmask, :binary_netmask,
      :wildcard, :binary_wildcard
    def initialize cidr = nil
      return unless cidr
      @cidr            = cidr
      @ip_address      = cidr.split('/').first
      @binary_netmask  = cidr_to_netmask cidr
      @binary_wildcard = cidr_to_wildcard cidr
      @hosts           = cidr_to_hosts cidr
      @ip_range        = generate_ip_range
    end

    def netmask
      to_dec binary_netmask
    end

    def wildcard
      to_dec binary_wildcard
    end

    def generate_ip_range
      a, b, c, d = ip_address.split('.')

      d = d.to_i
      ["#{a}.#{b}.#{c}.#{d}", "#{a}.#{b}.#{c}.#{d+hosts-1}"].uniq
    end

    def to_dec binary
      binary.split('.').map{|b| b.to_i(2)}.join('.')
    end

    def cidr_to_netmask cidr
      block = normalize cidr
      ('1'*block).ljust(32, '0').scan(/[01]{8}/).join('.')
    end

    def cidr_to_wildcard cidr
      block = normalize cidr
      ('0'*block).ljust(32, '1').scan(/[01]{8}/).join('.')
    end

    def cidr_to_hosts cidr
      return 1 if cidr.match %r{/32$}
      binary = cidr_to_netmask cidr
      (2**binary.scan('0').size) - 2
    end

    private
    def normalize cidr
      block = cidr.split('/').last.to_i
      if 8 > block || block > 32
        raise InvalidCIDRException.new "#{block} is an invalid CIDR address"
      else
        block
      end
    end

  end

  class InvalidCIDRException < Exception
  end
end
