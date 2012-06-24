dep 'rbenv' do
  requires '1.9.3.rbenv'
  version = '1.9.3-p194'
  met? { shell "rbenv global | grep #{version}" }
  meet { log_shell "Setting #{version} as the global rbenv default", "rbenv global #{version}" }
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

meta :rbenv do
  accepts_value_for :version, :basename
  accepts_value_for :patchlevel
  accepts_block_for :customise
  template {
    def version_spec
      "#{version}-#{patchlevel}"
    end
    def prefix
      "~/.rbenv/versions" / version_spec
    end
    def version_group
      version.scan(/^\d\.\d/).first
    end
    requires 'rbenv-configured', 'yaml headers.managed'
    met? {
      (prefix / 'bin/ruby').executable? and
      shell(prefix / 'bin/ruby -v')[/^ruby #{version}#{patchlevel}\b/]
    }
    meet {
      yaml_location = shell('brew info libyaml').split("\n").collapse(/\s+\(\d+ files, \S+\)/).first
      handle_source "http://ftp.ruby-lang.org/pub/ruby/#{version_group}/ruby-#{version_spec}.tar.gz" do |path|
        invoke(:customise)
        log_shell 'Configure', "./configure --prefix='#{prefix}' --with-libyaml-dir='#{yaml_location}' CC=/usr/bin/gcc-4.2"
        log_shell 'Build',     "make -j#{Babushka.host.cpus}"
        log_shell 'Install',   "make install"

        # ruby-1.9.2 doesn't install bin/* when the build path contains a dot-dir.
        shell "cp bin/* #{prefix / 'bin'}"
      end
    }
    after {
      log_shell 'rbenv rehash', 'rbenv rehash'
    }
  }
end

dep '1.9.2.rbenv' do
  patchlevel 'p290'
end

dep '1.9.3.rbenv' do
  patchlevel 'p194'
end