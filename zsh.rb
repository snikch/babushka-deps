dep 'oh-my-zsh' do
  requires 'zsh as user shell', 'zsh as system shell'
  def source
    'https://github.com/robbyrussell/oh-my-zsh.git'
  end
  def path
    File.expand_path '~/.oh-my-zsh'
  end
  met? { File.exists?(path) }
  meet { git source, :to => path }
end

dep 'zsh as user shell' do
  requires 'zsh.managed'
  met? { shell "finger -m `whoami` | grep zsh" }
  meet { sudo("chsh -s '#{which('zsh')}' #{ENV['USER']}") }
end

dep 'zsh as system shell' do
  met? { File.read('/etc/shells').to_s =~ /#{which('zsh')}/ }
  meet { sudo "echo `which zsh` >> /etc/shells" }
end

dep 'zsh.managed'
