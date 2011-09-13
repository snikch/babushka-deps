dep 'alias-bx' do
  met? {
    shell? "grep 'function bx()' $HOME/.bash_profile"
  }
  meet {
    cd('~') {
      log_shell "Creating alias 'bx' for 'bundle exec'",
        %Q{echo 'function bx() { $HOME/.rbenv/shims/bundle exec "$@" ;}' >> .bash_profile}

    }
  }
  after {
    log "NOTE: Please log out/in or source your ~/.bash_profile"
  }
end
