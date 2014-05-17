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
        "#{dirname}/.gitignore",
        "#{dirname}/README.md",
        "#{dirname}/AUTHORS.md"])

      system("cd #{dirname} && git init")

      puts "=> Created site `#{dirname}` successfully".colorize(:green)
    end

    def self.build_site
      puts "=> Building site..."

      if self.validate_site == true
        puts "==> Site conforms".colorize(:green)
      else
        exit
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

      Dir.new('.').each do |f|
        next if File.directory?(f) || File.extname(f) != '.html'

        if ! File.readlines(f).grep(/{content}/).any?
          puts "==> Error: `#{File.basename(f)}` does not have a content tag".colorize(:red)
          return false
        elsif ! File.readlines(f).grep(/{footer}/).any?
          puts "==> Error: `#{File.basename(f)}` does not have a footer tag".colorize(:red)
          return false
        elsif ! File.readlines(f).grep(/{menu}/).any?
          puts "==> Warning: `#{File.basename(f)}` does not have a menu tag".colorize(:yellow)
          return true
        end
      end

      return true
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
  end
end
