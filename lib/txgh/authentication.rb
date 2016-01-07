require "dotenv"

module Txgh
  class Authentication
    VARIABLES = %w[
      GITHUB_API_USERNAME
      GITHUB_API_TOKEN
      GITHUB_PUSH_BRANCH
      GITHUB_CONFIG_BRANCH
      TX_API_USERNAME
      TX_API_PASSWORD
      TX_PUSH_BRANCH
      TX_CONFIG_PATH
    ]

    def initialize(file = File.expand_path("~/.txgh"))
      @file = file
    end

    attr_reader :file

    def loaded?
      VARIABLES.all? { |var| ENV.include?(var) }
    end

    def can_load?
      if !loaded? && File.exist?(file)
        Dotenv.load(file)
      end

      if !loaded?
        ask
      end

      loaded?
    end

    def ask
      VARIABLES.each do |var|
        print "Please enter your #{var}:  "
        value = gets.strip
        redo unless value =~ /\S/
        ENV[var] = value
      end
      save
    end

    def save
      open(file, "w") do |env|
        VARIABLES.each do |var|
          env.puts "#{var}=#{ENV[var]}"
        end
      end
    end

    def show_keys
       puts "#{VARIABLES}"
    end

    def show_values
      VARIABLES.each do |var|
        puts "#{var}=#{ENV[var]}"
      end
    end

    def authenticate(twitter_client_config)
      VARIABLES.each do |var|
        twitter_client_config.send(
          "#{var.sub(/\ATWITTER_/, '').downcase}=",
          ENV[var]
        )
      end
    end
  end
end
