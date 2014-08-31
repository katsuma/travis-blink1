require "travis/blink1/version"
require "open3"
require 'blink1'

module Travis
  module Blink1
    SLEEP_SEC = 30

    GREEN = [0, 255, 0].freeze
    RED   = [255, 0, 0].freeze

    def run
      blink1 = Blink1.new
      blink1.open

      Signal.trap(:INT) { dispose_blink1(blink1) }

      repository_name = fetch_respository_name
      repository = Travis::Repository.find(repository_name)

      begin
        state = repository.last_build.state
        case state
        when 'passed'
          blink1.set_rgb(*GREEN)
        when 'errored'
          blink1.blink(*RED, SLEEP_SEC)
        end
        sleep(SELEEP_SEC)
      end while true
    ensure
      dispose_blink1(blink1)
    end

    def fetch_repository_name
      unless repository_name = ARGV.first
        results = *Open3.capture2("git remote -v | grep push | awk '{ print $2 }'")
        repository_name_regexp = /github\.com\/(.+)/
        repository_name = results.first.scan(repository_name_regexp).flatten.first
      end
      repository_name

    rescue
      messages = "Specify repository name. Try \"travis-blink1 user/repo\" or set remote address by \"git remote add origin https://github.com/user/repo.git\""
      raise Argumenterror.new(messages)
    end

    def dispose_blink1(blink1)
      return unless blink1
      blink1.off
      blink1.close
    end
  end
end
