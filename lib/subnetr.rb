require "subnetr/version"

module Subnetr
  class Calc

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
      cidr = cidr.gsub(/\W/, '').to_i if cidr.respond_to?('gsub')
      cidr < 8 ? 8 : cidr
    end

  end
end
