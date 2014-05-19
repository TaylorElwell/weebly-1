require 'weebly/version'
require 'zip'
require 'webrick'
require 'colorize'

module Weebly
  class Weebly
    def self.create_site(dirname, opts)
      if dirname == nil || dirname.length < 1
        puts '=> Error: No name provided'.colorize(:red)
        exit
      end

      begin
        Dir.mkdir dirname
      rescue
        puts "=> Error: Directory `#{dirname}` already exists".colorize(:red)
      end
 
      FileUtils::mkdir_p ["#{dirname}/css", "#{dirname}/js", "#{dirname}/img"]
      FileUtils::touch([
        "#{dirname}/css/main_style.css", 
        "#{dirname}/js/#{dirname}.js",
        "#{dirname}/index.html",
        "#{dirname}/splash.html",
        "#{dirname}/no-header.html",
        "#{dirname}/landing.html",
        "#{dirname}/.gitignore",
        "#{dirname}/README.md",
        "#{dirname}/AUTHORS.md"])
      system("cd #{dirname} && git init > /dev/null 2>&1")

      puts "=> Created site `#{dirname}` successfully".colorize(:green)
    end

    def self.build_site(buildopts)
      puts "=> Building site..."

      if ! buildopts.n
        if self.validate_site == true
          puts "==> Site conforms".colorize(:green)
        else
          exit
        end
      end

      if ! File.exist?("index.html")
        puts "=> Error: Not a Weebly site".colorize(:red)
        exit
      end

      dirname = File.split(Dir.getwd)[-1]
      FileUtils.rm_rf("/tmp/#{dirname}") if File.directory?("/tmp/#{dirname}")
      FileUtils.rm_rf("bin") if File.directory?("bin")
      FileUtils.mkdir_p ["/tmp/#{dirname}", "bin"]
      
      FileUtils.cp(Dir["js/**/*"], "/tmp/#{dirname}/")
      FileUtils.cp(Dir["css/**/*"], "/tmp/#{dirname}/")
      FileUtils.cp(Dir["img/**/*"], "/tmp/#{dirname}/")
      FileUtils.cp("index.html", "/tmp/#{dirname}/index.html")

      Zip::File.open("bin/#{dirname}.zip", Zip::File::CREATE) do |zip|
        Dir["/tmp/#{dirname}/*"].each do |f|
          puts "==> #{File.basename(f)}".colorize(:green)
          zip.add(File.basename(f), f)
        end
      end

      FileUtils.rmdir("/tmp/#{dirname}")
      puts "=> Done".colorize(:green)
    end

    def self.validate_site
      if ! File.exist?("index.html")
        puts "=> Error: Not a Weebly site".colorize(:red)
        return false
      end

      errors  = []
      success = true

      Dir.new('.').each do |f|
        next if File.directory?(f) || File.extname(f) != '.html'

        if ! self.validate_tag(/{content}/, f)
          errors << "==> Error: `#{File.basename(f)}` does not have a content tag"
            .colorize(:red)
        end

        if ! self.validate_tag(/{footer}/, f)
          errors << "==> Error: `#{File.basename(f)}` does not have a footer tag"
            .colorize(:red)
        end

        if ! self.validate_tag(/{title}/, f)
          errors << "==> Error: `#{File.basename(f)}` does not have a title tag"
            .colorize(:red)
        end

        if ! self.validate_tag(/{menu}/, f)
          errors << "==> Error: `#{File.basename(f)}` does not have a menu tag"
            .colorize(:red)
        end
      end

      puts errors if errors.length > 0
      return success
    end

    def self.serve_site
      if ! File.exist?("index.html")
        puts "=> Error: Not a Weebly site".colorize(:red)
        exit
      end

      self.build

      spath   = "/tmp/#{File.split(Dir.getwd)[-1]}/"
      server  = WEBrick::HTTPServer.new(:Port => 8000, :DocumentRoot => spath)
      
      trap 'INT' do server.shutdown end
      server.start
    end

    def self.validate_tag(tag, file)
      return false if ! File.readlines(file).grep(tag).any?
      return true
    end
  end
end
