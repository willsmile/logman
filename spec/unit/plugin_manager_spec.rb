# frozen_string_literal: true

RSpec.describe Logman::PluginManager do
  let(:config_path) { CONFIG_FIXTURES_PATH + '/' + 'config.yml' }
  let(:config) { Logman::Config.new(config_path) }
  let(:plugin_manager) { Logman::PluginManager.new(config) }

  describe '#execute' do
    context 'non-exist plugin' do
      let(:command) { 'non-exist-plugin' }

      it 'should raise error' do
        expect{ plugin_manager.execute(command) }.to raise_error Logman::ValidationError, "Please setup a valid plugin name."
      end
    end

    context 'command empty plugin' do
      let(:command) { 'empty-plugin' }

      it 'should raise error' do
        expect{ plugin_manager.execute(command) }.to raise_error Logman::ValidationError, "Please setup a valid plugin command."
      end
    end

    context 'invalid plugin' do
      let(:command) { 'invalid-plugin' }

      it 'should raise error' do
        expect{ plugin_manager.execute(command) }.to raise_error Errno::ENOENT
      end
    end

    context 'valid but error raising plugin' do
      let(:command) { 'valid-but-error-plugin' }

      it 'should raise error' do
        expect{ plugin_manager.execute(command) }.to raise_error RuntimeError
      end
    end

    context 'valid plugin' do
      let(:command) { 'valid-plugin' }

      it 'should execute command successfully' do
        expect{ plugin_manager.execute(command) }.to output("valid plugin\n").to_stdout_from_any_process
      end
    end
  end
end
