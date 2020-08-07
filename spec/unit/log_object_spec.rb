# frozen_string_literal: true

RSpec.describe Logman::LogObject do
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
        log = Logman::LogObject.new()
        expect { log.generate }.to output("Log file generation successed.\n").to_stdout
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
        log = Logman::LogObject.new()
        expect { log.generate }.to output("Log file exists.\n").to_stdout
      end
    end
  end
end
