require 'spec_helper'

describe Travis::Blink1 do
  describe "version" do
    it "has a version number" do
      expect(Travis::Blink1::VERSION).not_to be nil
    end
  end

  describe "#fetch_repositry_name" do
    subject do
      Travis::Blink1.fetch_repository_name
    end

    context "when argument is given" do
      before do
        allow(ARGV).to receive(:first).and_return(repository_name)
      end

      let(:repository_name) do
        'katsuma/travis-blink1'
      end

      it "returns repository name" do
        expect(subject).to eq(repository_name)
      end
    end

    context "when argument is not given" do
      before do
        allow(ARGV).to receive(:first).and_return(nil)
        allow(Open3).to receive(:capture2).and_return([repository_url, nil])
      end

      context "and when git is set" do
        let(:repository_url) do
          "https://github.com/katsuma/travis-blink1"
        end

        let(:repository_name) do
          "katsuma/travis-blink1"
        end

        it "returns repository name" do
          expect(subject).to eq(repository_name)
        end
      end

      context "and when git is not set" do
        let(:repository_url) do
          ""
        end

        it "raises an ArgumentError" do
          expect { subject }.to raise_error(ArgumentError)
        end
      end
    end
  end

  describe "#notify_by" do
    subject do
      Travis::Blink1.notify_by(state, blink1: blink1)
    end


    context "when state is passed" do
      let(:state) do
        "passed"
      end

      let(:blink1) do
        double(:blink1, set_rgb: nil)
      end

      it "sets green color" do
        expect(blink1).to receive(:set_rgb).with(*Travis::Blink1::GREEN)
        subject
      end
    end

    context "when state is errored" do
      let(:state) do
        "errored"
      end

      let(:blink1) do
        double(:blink1, blink: nil)
      end

      it "blinks with red color" do
        expect(blink1).to receive(:blink).with(*Travis::Blink1::RED, anything)
        subject
      end
    end
  end


  describe "#run" do
    subject do
      Travis::Blink1.run
    end

    before do
      stub_blink1

      allow(Travis::Blink1).to receive(:fetch_repository_name).and_return(repository_name)
      allow(Travis::Blink1).to receive(:loop?).and_return(false)
      allow(Travis::Blink1).to receive(:sleep).and_return(true)
      allow(Travis::Blink1).to receive(:banner).and_return("")
    end

    let(:repository_name) do
      "katsuma/travis-blink1"
    end

    let(:repository) do
      double(reload: double(last_build: double(state: state)))
    end

    context "when Travis CI is passed" do
      let(:state) do
        "passed"
      end

      before do
        allow(Travis::Repository).to receive(:find).and_return(repository)
      end

      it "notifies by 'passed'" do
        expect(Travis::Blink1).to receive(:notify_by).with('passed', anything)
        subject
      end
    end

    context "when Travis CI is errored" do
      let(:state) do
        "errored"
      end

      before do
        allow(Travis::Repository).to receive(:find).and_return(repository)
      end

      it "notifies by 'errored'" do
        expect(Travis::Blink1).to receive(:notify_by).with('errored', anything)
        subject
      end
    end

    context "When Travis CI is started" do
      let(:state) do
        "started"
      end

      before do
        allow(Travis::Repository).to receive(:find).and_return(repository)
      end

      it "notifies by 'errored'" do
        expect(Travis::Blink1).to receive(:notify_by).with('started', anything)
        subject
      end
    end

    def stub_blink1
      allow_any_instance_of(Blink1).to receive_messages(
        on: true,
        off: true,
        open: true,
        close: true,
        blink: true,
      )
    end
  end
end
