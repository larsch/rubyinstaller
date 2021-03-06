require 'ostruct'

module RubyInstaller
  unless defined?(ROOT)
    # Root folder
    ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))

    # Console based utilities
    SEVEN_ZIP = File.expand_path(File.join(ROOT, 'sandbox', 'extract_utils', '7za.exe'))
    BSD_TAR = File.expand_path(File.join(ROOT, 'sandbox', 'extract_utils', 'basic-bsdtar.exe'))

    # MinGW files
    MinGW = OpenStruct.new(
      :release => 'current',
      :version => '3.4.5',
      :url => "http://downloads.sourceforge.net/mingw",
      :target => 'sandbox/mingw',
      :files => [
        'mingwrt-3.15.2-mingw32-dll.tar.gz',
        'mingwrt-3.15.2-mingw32-dev.tar.gz',
        'w32api-3.13-mingw32-dev.tar.gz',
        'binutils-2.19.1-mingw32-bin.tar.gz',
        'gcc-core-3.4.5-20060117-3.tar.gz',
        'gcc-g++-3.4.5-20060117-3.tar.gz',
        'gdb-6.8-mingw-3.tar.bz2'
      ]
    )

    MSYS = OpenStruct.new(
      :release => 'technology-preview',
      :version => '1.0.11',
      :url => "http://downloads.sourceforge.net/mingw",
      :target => 'sandbox/msys',
      :files => [
        'msysCORE-1.0.11-20080826.tar.gz',
        'findutils-4.3.0-MSYS-1.0.11-3-bin.tar.gz',
        'MSYS-1.0.11-20090120-dll.tar.gz',
        'tar-1.19.90-MSYS-1.0.11-2-bin.tar.gz',
        'autoconf2.5-2.61-1-bin.tar.bz2',
        'autoconf-4-1-bin.tar.bz2',
        'perl-5.6.1-MSYS-1.0.11-1.tar.bz2',
        'crypt-1.1-1-MSYS-1.0.11-1.tar.bz2',
        'bison-2.3-MSYS-1.0.11-1.tar.bz2'
      ]
    )

    Ruby18 = OpenStruct.new(
      :version => '1.8.7-p302',
      :url => "http://ftp.ruby-lang.org/pub/ruby/1.8",
      :checkout => 'http://svn.ruby-lang.org/repos/ruby/branches/ruby_1_8_7',
      :checkout_target => 'downloads/ruby_1_8',
      :target => 'sandbox/ruby_1_8',
      :build_target => 'sandbox/ruby18_build',
      :install_target => 'sandbox/ruby18_mingw',
      :configure_options => [
        '--with-winsock2',
        '--disable-install-doc',
        "CFLAGS='-g -O2 -DFD_SETSIZE=256'"
      ],
      :files => [
        'ruby-1.8.7-p302.tar.bz2'
      ],
      :dependencies => [
        :gdbm, :iconv, :openssl, :pdcurses, :zlib
      ],
      :excludes => [
        'libcharset1.dll'
      ],
      :installer_guid => '{F6377277-9DF1-4a1f-A487-CB5D34DCD793}'
    )

    # switch to Ruby 1.8.6 for "1.8" branch at runtime
    if ENV['COMPAT'] then
      Ruby18.version = '1.8.6-p398'
      Ruby18.checkout = 'http://svn.ruby-lang.org/repos/ruby/branches/ruby_1_8_6'
      Ruby18.files = ['ruby-1.8.6-p398.tar.bz2']
      Ruby18.installer_guid = '{CE65B110-8786-47EA-A4A0-05742F29C221}'
    end

    Ruby19 = OpenStruct.new(
      :version => "1.9.2-p0",
      :url => "http://ftp.ruby-lang.org/pub/ruby/1.9",
      :checkout => 'http://svn.ruby-lang.org/repos/ruby/branches/ruby_1_9_2',
      :checkout_target => 'downloads/ruby_1_9',
      :target => 'sandbox/ruby_1_9',
      :build_target => 'sandbox/ruby19_build',
      :install_target => 'sandbox/ruby19_mingw',
      :configure_options => [
        '--enable-shared',
        '--disable-install-doc'
      ],
      :files => [
        'ruby-1.9.2-p0.tar.bz2'
      ],
      :dependencies => [
        :ffi, :gdbm, :iconv, :openssl, :pdcurses, :yaml, :zlib
      ],
      :excludes => [
        'libcharset1.dll'
      ],
      :installer_guid => '{BD5F3A9C-22D5-4C1D-AEA0-ED1BE83A1E67}'
    )

    # COMPAT mode for Ruby 1.9.1
    if ENV['COMPAT'] then
      Ruby19.version = '1.9.1-p430'
      Ruby19.checkout = 'http://svn.ruby-lang.org/repos/ruby/branches/ruby_1_9_1'
      Ruby19.files = ['ruby-1.9.1-p430.tar.bz2']
      Ruby19.dependencies = [:gdbm, :iconv, :openssl, :pdcurses, :zlib]
      Ruby19.installer_guid = '{11233A17-BFFC-434A-8FC8-2E93369AF008}'
    end

    # alter at runtime the checkout and versions of 1.9
    # TODO define distinct GUID for dev versions?
    if ENV['TRUNK'] then
      Ruby19.version = '1.9.3'
      Ruby19.checkout = 'http://svn.ruby-lang.org/repos/ruby/trunk'
    end

    Zlib = OpenStruct.new(
      :release => "alternate",
      :version => "1.2.5",
      :url => "http://github.com/downloads/oneclick/rubyinstaller",
      :target => 'sandbox/zlib',
      :files => [
        'zlib125-dll.zip'
      ]
    )

    PureReadline = OpenStruct.new(
      :release => 'experimental',
      :version => '0.5.2-0.2.0',
      :url => 'http://cloud.github.com/downloads/luislavena/rb-readline',
      :target => 'sandbox/rb-readline',
      :files => [
        'rb-readline-0.2.0.zip'
      ]
    )

    PdCurses = OpenStruct.new(
      :version => '3.3',
      :url => "http://downloads.sourceforge.net/pdcurses",
      :target => 'sandbox/pdcurses',
      :files => [
        'pdc33dll.zip'
      ]
    )

    ExtractUtils = OpenStruct.new(
        :url_1 => 'http://downloads.sourceforge.net/sevenzip',
        :url_2 => 'http://downloads.sourceforge.net/mingw',
        :target => 'sandbox/extract_utils',
        :files => {
          :url_1 => [
            '7za465.zip',
            '7z465.msi',
          ],
          :url_2 => [
            'basic-bsdtar-2.8.3-1-mingw32-bin.zip'
          ],
        }
    )

    OpenSsl = OpenStruct.new(
      :url => 'http://www.openssl.org/source',
      :version => '0.9.8o',
      :target => 'sandbox/src-openssl',
      :install_target => 'sandbox/openssl',
      :patches => 'resources/patches/openssl',
      :configure_options => [
        'mingw',
        'zlib-dynamic'
      ],
      :dllnames => {
        :libcrypto => 'libeay32-0.9.8-msvcrt.dll',
        :libssl => 'ssleay32-0.9.8-msvcrt.dll',
      },
      :files => [
        'openssl-0.9.8o.tar.gz',
      ]
    )

    LibYAML = OpenStruct.new(
      :url => 'http://pyyaml.org/download/libyaml',
      :version => '0.1.3',
      :target => 'sandbox/src-libyaml',
      :install_target => 'sandbox/libyaml',
      :patches => 'resources/patches/yaml',
      :configure_options => [
        '--enable-static',
        '--disable-shared'
      ],
      :files => [
        'yaml-0.1.3.tar.gz',
      ]
    )

    LibFFI = OpenStruct.new(
      :url => 'http://github.com/atgreen/libffi/tarball/v3.0.9',
      :version => '3.0.9',
      :target => 'sandbox/src-libffi',
      :install_target => 'sandbox/libffi',
      :patches => 'resources/patches/libffi',
      :configure_options => [
        '--enable-static',
        '--disable-shared'
      ],
      :files => [
        'libffi-3.0.9.tar.gz',
      ]
    )

    Iconv = OpenStruct.new(
      :release => 'official',
      :version => "1.9.2-1",
      :url => "http://downloads.sourceforge.net/gnuwin32",
      :target => 'sandbox/iconv',
      :files => [
        'libiconv-1.9.2-1-bin.zip',
        'libiconv-1.9.2-1-lib.zip'
      ]
    )

    Gdbm = OpenStruct.new(
      :release => 'official',
      :version => '1.8.3-1',
      :url => "http://downloads.sourceforge.net/gnuwin32",
      :target => 'sandbox/gdbm',
      :files => [
        'gdbm-1.8.3-1-bin.zip',
        'gdbm-1.8.3-1-lib.zip',
        'gdbm-1.8.3-1-src.zip'
      ]
    )

    RubyGems = OpenStruct.new(
      :release => 'official',
      :version => '1.3.7',
      :url => 'http://rubyforge.org/frs/download.php/70696',
      :checkout => 'http://github.com/rubygems/rubygems.git',
      :checkout_target => 'downloads/rubygems',
      :target => 'sandbox/rubygems',
      :configure_options => [
        '--no-ri',
        '--no-rdoc'
      ],
      :files => [
        'rubygems-1.3.7.tgz'
      ]
    )

    Book = OpenStruct.new(
      :release => 'official',
      :version => '2009-04-18',
      :url => 'http://www.sapphiresteel.com/IMG/zip',
      :target => 'sandbox/book',
      :files => [
        'book-of-ruby.zip'
      ]
    )
  end
end
