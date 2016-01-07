require 'config_env'

module Txgh
  class KeyManager

    def self.github_repo_config(config)
      ghkeys = ["GITHUB_API_USERNAME", "GITHUB_API_TOKEN", "GITHUB_PUSH_BRANCH", "GITHUB_CONFIG_BRANCH"]
      ghmappings = {"GITHUB_API_USERNAME" => "api_username", "GITHUB_CONFIG_BRANCH" => "branch", "GITHUB_API_TOKEN" => "api_token", "GITHUB_PUSH_BRANCH" => "push_source_to"}
      config.keep_if {|k,_| ghkeys.include? k }
      config.keys.each { |k| config[ ghmappings[k] ] = config.delete(k) if ghmappings[k] }
      config
    end

    def self.transifex_project_config(config)
      txkeys = ["TX_CONFIG_PATH","TX_API_USERNAME","TX_API_PASSWORD", "TX_PUSH_BRANCH" ]
      txmappings = {"TX_CONFIG_PATH" => "tx_config", "TX_API_USERNAME" => "api_username", "TX_API_PASSWORD" => "api_password", "TX_PUSH_BRANCH" => "push_translations_to" }
      config.keep_if {|k,_| txkeys.include? k }
      config.keys.each { |k| config[ txmappings[k] ] = config.delete(k) if txmappings[k] }
      config
    end

    def self.yaml
      path = File.join(File.dirname(File.expand_path(__FILE__)), "txgh.yml")
      puts path
      YAML.load(ERB.new(File.read(path)).result)

    end
    private_class_method :new
  end
end
