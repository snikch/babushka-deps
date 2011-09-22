dep 'alias-bx-rbenv' do
  met? {
    shell? "grep 'bx()' $HOME/.bashrc"
  }
  meet {
    cd('~') {
      log_shell "Creating alias 'bx' for 'bundle exec'",
        %Q{echo 'bx() { if [[ $1 == "bp" ]]; then command shift && $HOME/.rbenv/shims/bundle exec bluepill --no-privileged "$@"; else command $HOME/.rbenv/shims/bundle exec "$@"; fi; }' >> .bashrc}
    }
  }
  after {
    log "NOTE: Please log out/in or source your ~/.bashrc"
  }
end

dep 'alias-bx' do
  met? {
    shell? "grep 'bx()' $HOME/.bashrc"
  }
  meet {
    cd('~') {
      log_shell "Creating alias 'bx' for 'bundle exec'",
        %Q{echo 'bx() { if [[ $1 == "bp" ]]; then command shift && /usr/local/bin/bundle exec bluepill "$@"; else command /usr/local/bin/bundle exec "$@"; fi; }' >> .bashrc}

    }
  }
  after {
    log "NOTE: Please log out/in or source your ~/.bashrc"
  }
end
