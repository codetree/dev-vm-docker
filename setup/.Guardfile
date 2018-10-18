# rspec configuration
rspec_opts = {
  cmd: 'spring rspec --format documentation',
  all_on_start: true,
  run_all: { cmd: 'spring rspec --format progress --profile 5' }
}

rubocop_opts = {
  all_on_start: true,
  cli: ['--display-cop-names']
}

group :gem do
  guard :rspec, rspec_opts do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})       { |m| "spec/#{m[1]}_spec.rb" }
  end
end

group :rails, halt_on_fail: true do
  guard :rspec, rspec_opts do
    watch(%r{^spec/(.+)_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})       { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/(.+)\.rb$})       { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^app/(.+)\.erb$})      { |m| "spec/#{m[1]}.erb_spec.rb" }
    watch(%r{^app/controllers/(.+)_controller\.rb}) { |m| "spec/routing/#{m[1]}_routing_spec.rb" }
    watch('config/routes.rb') { 'spec/routing' }
  end

  guard :rubocop, rubocop_opts do
    watch(%r{^spec/.+\.rb$})
    watch(%r{^lib/(.+)\.rb$})
    watch(%r{^app/(.+)\.rb$})
    watch(%r{^db/(.+)\.rb$})
    watch(%r{^config/(.+)\.rb$})
  end
end
