namespace :code do
  desc 'Run automatically rspec, rubocop, rails_best_practices, brakeman, and
        open coverage/index.html'
  task check: :environment do
    Kernel.system 'rspec'
    Kernel.system 'rubocop'
    Kernel.system 'rails_best_practices .'
    Kernel.system 'brakeman'
    Kernel.system 'open coverage/index.html'
  end
end
