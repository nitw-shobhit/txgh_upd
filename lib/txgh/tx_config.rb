require 'parseconfig'
require_relative 'tx_resource'

module Txgh
  class TxConfig
    def initialize(path)
      config = ParseConfig.new(path)
      @resources = []
      config.get_groups().each do |group|
        if group == 'main'
          main = config[group]
          @lang_map = {}
          if main['lang_map']
            @lang_map = Txgh::TxConfig.parse_lang_map(main['lang_map'])
          end
        else
          @resources.push(Txgh::TxConfig.parse_resource(group, config[group]))
        end
      end
    end

    def self.parse_lang_map(lang_map)
      result = {}
      lang_map.split(',').each do |m|
        key_value = m.split(':', 2)
        result[key_value[0].strip] = key_value[1].strip
      end
    end

    def self.parse_resource(name, resource)
      id = name.split('.', 2)
      TxResource.new(id[0].strip, id[1].strip, resource['type'],
                     resource['source_lang'], resource['source_file'],
                     resource['lang_map'], resource['file_filter'])
    end

    def resources
      @resources
    end

    def lang_map
      @lang_map
    end
  end
end
