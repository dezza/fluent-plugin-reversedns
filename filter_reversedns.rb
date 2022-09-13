require 'fluent/plugin/filter'

module Fluent
  module Plugin
    class ReverseDNSFilter < Filter
      Fluent::Plugin.register_filter('reversedns', self)

      config_param :reversedns_keys, :array, value_type: :string, default: ['host']

      def filter(_, _, record)
        @reversedns_keys.each do |k,v|
          ip = IPAddr.new record[k] if record[k]
          begin
            host = Resolv.getname(ip.to_string)
          rescue Resolv::ResolvError
            next
          end
          record["#{k}_host"] = host if host
        end
        record
      end
    end
  end
end
