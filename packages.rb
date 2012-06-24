dep 'yaml headers.managed' do
    installs {
        via :brew, 'libyaml'
        via :apt, 'libyaml-dev'
      }
        provides []
end
