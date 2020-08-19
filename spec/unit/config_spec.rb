# frozen_string_literal: true

RSpec.describe Logman::Config do

  describe '#load' do
    let(:config_path) { logman_path + '/' + config_filename }

    context 'use an available config file' do
      let(:logman_path) { CONFIG_FIXTURES_PATH }
      let(:config_filename) { 'config.yml' }

      it 'config file exists' do
        expect(File.exist?(config_path)).to be true
      end
      it 'should load config successfully' do
        config = Logman::Config.new(config_path).load
        expect(config.keys.size).to be > 0
      end
    end

    context 'use an empty config file' do
      let(:logman_path) { CONFIG_FIXTURES_PATH }
      let(:config_filename) { 'empty_config.yml' }

      it 'config file exists' do
        expect(File.exist?(config_path)).to be true
      end
      it 'should load config successfully' do
        config = Logman::Config.new(config_path).load
        expect(config.keys.size).to be 0
      end
    end

    context 'use a non-exist config file' do
      let(:logman_path) { CONFIG_FIXTURES_PATH }
      let(:config_filename) { 'non_exist_config.yml' }

      it 'config file does not exist' do
        expect(File.exist?(config_path)).to be false
      end
      it 'should load config unsuccessfully' do
        expect{ Logman::Config.new(config_path).load }.to raise_error Logman::ValidationError, "Please use a valid config path."
      end
    end
  end
end
