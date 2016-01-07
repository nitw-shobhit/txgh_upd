require_relative 'key_manager'
require_relative 'github_api'
require_relative 'tx_project'
require_relative 'tx_config'

module Txgh
  class GhRepository
    def initialize(name,ghconfig,txconfig)
      @name = name
      @config = ghconfig
      @txconfig = txconfig
      @branch = @config['branch']
    end

    def name
      @name
    end

    def branch
      @branch
    end

    def transifex_project
      @transifex_project = @transifex_project ||
        Txgh::TxProject.new(@config['push_source_to'],@txconfig)
    end

    def api
      @api = @api || Txgh::GitHubApi.new(
      @config['api_username'], @config['api_token'])
    end

  end
end
