dep 'meslo.ttf' do
    source 'http://github.com/downloads/andreberg/Meslo-Font/Meslo%20LG%20DZ%20v1.0.zip'
      ttf_filename "MesloLGM-DZ-Regular.ttf"
end

meta 'ttf' do
  accepts_list_for :source
  accepts_list_for :extra_source
  accepts_list_for :ttf_filename

  template {
    requires 'user font dir exists'
    prepare {
      setup_source_uris
    }
    met? {
      "~/Library/Fonts/#{ttf_filename.first}".p.exists?
    }
    meet {
      process_sources do
        Dir.glob("*.ttf") do |font|
          log_shell "Installing #{font}", "cp #{font} ~/Library/Fonts"
        end
      end
    }
  }
end
