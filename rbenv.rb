dep 'rbenv-install' do
  met? {
    shell? 'PATH="$HOME/.rbenv/bin:$PATH" rbenv'
  }
  meet {
    cd('~') {
      log_shell 'Cloning rbenv', "git clone git://github.com/sstephenson/rbenv.git .rbenv"
      log_shell 'rbenv setup', %Q{echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> .bash_profile}
      shell %Q{echo 'eval "$(rbenv init -)"' >> .bash_profile}
      # TODO: figure out why 'exec' borks.
    }
  }
end
