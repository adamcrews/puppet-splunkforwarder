notification :off

guard 'rake', :task => 'test' do
  watch(%r{^manifests\/(.+)\.pp$})
  watch(%r{^spec\/classes\/**\/(.+)_spec\.rb$})
end
