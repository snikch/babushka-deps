dep 'rbenv' do
  requires 'rbenv-configured'
end

dep 'rbenv-configured' do
  requires 'rbenv-install'
  met? { '$HOME/.bashrc'.p.grep 'rbenv' }
  meet { 
    log_shell 'rbenv setup', %Q{echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> .bashrc}
    shell %Q{echo 'eval "$(rbenv init -)"' >> .bashrc}
  }
  after {
    log "NOTE: Please log out/in or source your ~/.bashrc"
  }
end

dep 'rbenv-install' do
  met? {
    shell? 'PATH="$HOME/.rbenv/bin:$PATH" rbenv'
  }
  meet {
    cd('~') {
      log_shell 'Cloning rbenv', "git clone git://github.com/sstephenson/rbenv.git .rbenv"
      # TODO: figure out why 'exec' borks.
    }
  }
end
