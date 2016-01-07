require_relative 'key_manager'
require_relative 'gh_repository'
require_relative 'transifex_api'
require_relative 'tx_config'

module Txgh
  class TxProject
    def initialize(project_name,config)
      @name = project_name
      @config = config
      @tx_config = Txgh::TxConfig.new(@config['tx_config'])
    end

    def github_repo
      @github_repo = @github_repo ||
        Txgh::GitHubRepo.new(@config['push_translations_to'])
    end

    def resource(slug)
      @tx_config.resources.each do |resource|
        return resource if resource.resource_slug == slug
      end
    end

    def resources
      @tx_config.resources
    end

    def api
      @api = @api || Txgh::TransifexApi.instance(
      @config['api_username'], @config['api_password'])
    end

    def lang_map(tx_lang)
      if @tx_config.lang_map.include?(tx_lang)
        @tx_config.lang_map[tx_lang]
      else
        tx_lang
      end
    end
  end
end