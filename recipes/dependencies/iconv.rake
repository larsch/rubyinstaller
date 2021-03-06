require 'rake'
require 'rake/clean'

namespace(:dependencies) do
  namespace(:iconv) do
    # zlib needs mingw and downloads
    package = RubyInstaller::Iconv
    directory package.target
    CLEAN.include(package.target)

    # Put files for the :download task
    dt = checkpoint(:iconv, :download)
    package.files.each do |f|
      file_source = "#{package.url}/#{f}"
      file_target = "downloads/#{f}"
      download file_target => file_source

      # depend on downloads directory
      file file_target => "downloads"

      # download task need these files as pre-requisites
      dt.enhance [file_target]
    end
    task :download => dt

    # Prepare the :sandbox, it requires the :download task
    et = checkpoint(:iconv, :extract) do
      dt.prerequisites.each { |f|
        extract(File.join(RubyInstaller::ROOT, f), package.target)
      }
    end
    task :extract => [:extract_utils, :download, package.target, et]

    # win_iconv needs some adjustments.
    # remove *.txt
    # remove src folder
    # leave zlib1.dll inside bin ;-)
    pt = checkpoint(:iconv, :prepare) do
      cd File.join(RubyInstaller::ROOT, package.target) do
        rm_rf "src"
        Dir.glob("*.txt").each do |path|
          rm_f path
        end
      end
    end
    task :prepare => [et, pt]

    task :activate => [:prepare] do
      puts "Activating Iconv version #{package.version}"
      activate(package.target)
    end
  end
end

task :iconv => [
  'dependencies:iconv:download',
  'dependencies:iconv:extract',
  'dependencies:iconv:prepare',
  'dependencies:iconv:activate'
]

task :dependencies => [:iconv] unless ENV['NODEPS']
