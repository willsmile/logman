# frozen_string_literal: true

RSpec.describe Logman::LogObject do
  let(:config_path) { ENV['LOGMANPATH'] + '/' + 'config.yml' }
  let(:config) { Logman::Config.new(config_path) }

  before do
    allow(Date).to receive(:today).and_return(today)
  end

  describe '#generate' do
    let(:today) { Date.new(2019, 0o4, 0o1) }
    let(:format) { "%y%m%dDL.md" }
    let(:filename) { Date.today.strftime(format) }

    context 'same name logfile does not exist' do
      before do
        FileUtils.rm_f(filename)
      end
      it 'should return a success message' do
        log = Logman::LogObject.new(config)
        expect { log.generate }.to output("Logfile generation successed.\n").to_stdout
      end
    end

    context 'same name logfile exists' do
      before do
        FileUtils.touch(filename)
      end
      after do
        FileUtils.rm_f(filename)
      end
      it 'should return a fail message' do
        log = Logman::LogObject.new(config)
        expect { log.generate }.to raise_error Logman::OperationError, "Logfile exists."
      end
    end
  end
end
