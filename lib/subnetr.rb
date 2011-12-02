require "subnetr/version"

module Subnetr
  class Calc
    attr_reader :cidr, :netmask, :binary_netmask, :hosts
    def initialize cidr = nil
      return unless cidr
      @cidr           = cidr
      @netmask        = cidr_to_netmask cidr
      @binary_netmask = cidr_to_binary cidr
      @hosts          = cidr_to_hosts cidr
    end

    def cidr_to_netmask cidr
      binary = cidr_to_binary cidr
      binary.split('.').map{|b| b.to_i(2)}.join('.')
    end

    def cidr_to_binary cidr
      cidr = normalize cidr
      ('1'*cidr).ljust(32, '0').scan(/[01]{8}/).join('.')
    end

    def cidr_to_hosts cidr
      cidr = normalize cidr
      return 1 if cidr == 32
      binary = cidr_to_binary cidr
      (2**binary.scan('0').size) - 2
    end

    private
    def normalize cidr
      cidr = cidr.split('/').last.to_i if cidr.respond_to?('split')
      if 8 > cidr || cidr > 32 || cidr == 31
        raise InvalidCIDRException.new "#{cidr} is an invalid CIDR address"
      else
        cidr
      end
    end

  end

  class InvalidCIDRException < Exception

  end
end
