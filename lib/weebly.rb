require 'weebly/version'
require 'zip'

module Weebly
  class Weebly
    def self.create_site(dirname)
      if dirname == nil || dirname.length < 1
        puts '=> Error: No name provided'
        return
      end

      begin
        Dir.mkdir dirname
      rescue
        puts "=> Error: Directory `#{dirname}` already exists"
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

      puts "=> Created site `#{dirname}` successfully"
    end

    def self.build_site
      puts "=> Building site..."

      if ! File.exist?("index.html")
        puts "=> Error: Not a Weebly site"
        return
      end

      dirname = File.split(Dir.getwd)[-1]
      FileUtils.rmdir("/tmp/#{dirname}") if File.directory?("/tmp/#{dirname}")
      FileUtils.rmdir("#bin") if File.directory?("#bin")
      FileUtils.rm("#{dirname}.zip") if File.exist?("#{dirname}.zip")
      FileUtils.mkdir_p ["/tmp/#{dirname}", "bin"]
      
      FileUtils.cp(Dir["js/**/*"], "/tmp/#{dirname}/")
      FileUtils.cp(Dir["css/**/*"], "/tmp/#{dirname}/")
      FileUtils.cp(Dir["img/**/*"], "/tmp/#{dirname}/")
      FileUtils.cp("index.html", "/tmp/#{dirname}/index.html")

      Zip::File.open("bin/#{dirname}.zip", Zip::File::CREATE) do |zip|
        Dir["/tmp/#{dirname}/*"].each do |f|
          puts "==> #{File.basename(f)}"
          zip.add(File.basename(f), f)
        end
      end

      FileUtils.rmdir("/tmp/#{dirname}")
      puts "=> Done"
    end
  end
end
