require 'rails_helper'

describe 'rake code:check', type: :task do
  it 'preloads the Rails environment' do
    expect(task.prerequisites).to include 'environment'
  end

  it 'runs rspec' do
    expect(Kernel).to receive(:system).with 'rspec'
    expect(Kernel).to receive(:system).with 'rubocop'
    expect(Kernel).to receive(:system).with 'rails_best_practices .'
    expect(Kernel).to receive(:system).with 'brakeman'
    expect(Kernel).to receive(:system).with 'open coverage/index.html'
    expect { task.execute }.not_to raise_error
  end
end
