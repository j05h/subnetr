require "subnetr/version"

module Subnetr
  class Calc

    def cidr_to_netmask cidr
      binary = cidr_to_binary cidr
      binary.split('.').map{|b| b.to_i(2)}.join('.')
    end

    def cidr_to_binary cidr
      cidr = cidr.gsub(/\W/, '').to_i if cidr.respond_to?('gsub')
      cidr = 8 if cidr < 8
      ('1'*cidr).ljust(32, '0').scan(/[01]{8}/).join('.')
    end

  end
end
