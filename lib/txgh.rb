require_relative "txgh/version"
require_relative "txgh/authentication"
require_relative "txgh/gh_repository"

module Txgh
  module_function

  def do_daemon
    Thread.abort_on_exception = true

    auth = Authentication.new
    abort "Could not create authentication." unless auth.can_load?
=begin
    stream = Stream.new(auth)
    ui     = UI.new
    stream.read
    ui.show(
      screen_name: stream.screen_name,
      timeline:    stream.timeline,
      mentions:    stream.mentions
    )
=end
  end
end