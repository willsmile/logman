# frozen_string_literal: true

RSpec.describe Logman::Post do
  let(:today) { Date.new(2019, 0o4, 0o1) }
  let(:format) { "%y%m%dDL.md" }
  let(:filename) { Date.today.strftime(format) }
  let(:config_path) { ENV['LOGMANPATH'] + '/' + 'config.yml' }
  let(:config) { Logman::Config.new(config_path).load }

  before do
    allow(Date).to receive(:today).and_return(today)
  end

  describe '#esa' do
    context 'towards an exist logfile' do
      before do
        FileUtils.touch(filename)
      end
      after do
        FileUtils.rm_f(filename)
      end

      it 'should return a successful message when esa response is valid' do
        response = Hashie::Mash.new(status: 201, body: {'number': 1})
        mock_esa_client = double('Esa Client')
        allow(mock_esa_client).to receive(:create_post).and_return(response)
        allow(mock_esa_client).to receive(:update_post).and_return(true)

        log = Logman::LogObject.new(config)
        post = Logman::Post.new(config)
        allow(post).to receive(:esa_client).and_return(mock_esa_client)
        expect { post.esa(log) }.to output("Post logfile #{filename} to esa successful.\n").to_stdout
      end

      it 'should return a unsuccessful message when esa response is valid but update post failed' do
        response = Hashie::Mash.new(status: 201, body: {'number': 1})
        mock_esa_client = double('Esa Client')
        allow(mock_esa_client).to receive(:create_post).and_return(response)
        allow(mock_esa_client).to receive(:update_post).and_return(false)

        log = Logman::LogObject.new(config)
        post = Logman::Post.new(config)
        allow(post).to receive(:esa_client).and_return(mock_esa_client)
        expect { post.esa(log) }.to output("Post logfile #{filename} to esa unsuccessful.\n").to_stdout
      end

      it 'should return an error message when esa response is invalid' do
        response = Hashie::Mash.new(status: 404)
        mock_esa_client = double('Esa Client')
        allow(mock_esa_client).to receive(:create_post).and_return(response)
        allow(mock_esa_client).to receive(:update_post).and_return(false)

        log = Logman::LogObject.new(config)
        post = Logman::Post.new(config)
        allow(post).to receive(:esa_client).and_return(mock_esa_client)
        expect { post.esa(log) }.to output("Cannot connect to esa.\n").to_stderr_from_any_process
      end
    end

    context 'towards a non-exist logfile' do
      before do
        FileUtils.rm_f(filename)
      end

      it 'should return an error message' do
        log = Logman::LogObject.new(config)
        post = Logman::Post.new(config)
        expect { post.esa(log) }.to raise_error(Errno::ENOENT)
      end
    end
  end

  describe '#slack' do
    context 'towards an exist logfile' do
      before do
        FileUtils.touch(filename)
      end
      after do
        FileUtils.rm_f(filename)
      end

      it 'should return a successful message when slack response is valid' do
        mock_slack_notifier = double('Slack Notifier')
        allow(mock_slack_notifier).to receive(:post).and_return(true)

        log = Logman::LogObject.new(config)
        post = Logman::Post.new(config)
        allow(post).to receive(:slack_notifier).and_return(mock_slack_notifier)
        expect { post.slack(log) }.to output("Post logfile #{filename} to slack successful.\n").to_stdout
      end

      it 'should return a unsuccessful message when slack response is invalid' do
        mock_slack_notifier = double('Slack Notifier')
        allow(mock_slack_notifier).to receive(:post).and_return(false)

        log = Logman::LogObject.new(config)
        post = Logman::Post.new(config)
        allow(post).to receive(:slack_notifier).and_return(mock_slack_notifier)
        expect { post.slack(log) }.to output("Post logfile #{filename} to slack unsuccessful.\n").to_stdout
      end
    end
    
    context 'towards a non-exist logfile' do
      before do
        FileUtils.rm_f(filename)
      end

      it 'should return an error message' do
        log = Logman::LogObject.new(config)
        post = Logman::Post.new(config)
        expect { post.slack(log) }.to raise_error(Errno::ENOENT)
      end
    end
  end
end
