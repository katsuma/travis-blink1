require "travis/blink1/version"
require "open3"
require 'blink1'
require 'travis'

module Travis
  module Blink1
    SLEEP_SEC = 30

    GREEN = [0, 255, 0].freeze
    RED   = [255, 0, 0].freeze

    def run
      blink1 = ::Blink1.new
      blink1.open

      Signal.trap(:INT) do
        dispose_blink1(blink1)
        exit
      end

      repository_name = fetch_repository_name
      repository = Travis::Repository.find(repository_name)

      begin
        state = repository.last_build.state
        notify_by(state, blink1: blink1)
        sleep(SLEEP_SEC)
      end while loop?
    end

    def fetch_repository_name
      unless repository_name = ARGV.first
        results = *Open3.capture2("git remote -v | grep push | awk '{ print $2 }'")
        repository_name_regexp = /github\.com\/(.+)/

        matched_name = results.first.match(repository_name_regexp)
        raise unless matched_name
        repository_name = matched_name[1]
      end
      repository_name
    rescue
      messages = "Specify repository name. Try \"travis-blink1 user/repo\" or set remote address by \"git remote add origin https://github.com/user/repo.git\""
      raise ArgumentError.new(messages)
    end

    def notify_by(state, blink1: nil)
      case state
      when 'passed'
        blink1.set_rgb(*GREEN)
      when 'errored'
        blink1.blink(*RED, SLEEP_SEC)
      end
    end

    def loop?
      true
    end

    def dispose_blink1(blink1)
      blink1.off
      blink1.close
    rescue
    end
  end
end
