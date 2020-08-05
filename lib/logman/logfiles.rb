# frozen_string_literal: true

require 'fileutils'

module Logman
  module Logfiles
    def self.archive
      mydir = Dir.pwd
      files = Dir.entries('.').select { |f| File.file?(f) && f.match(/^\d*DL.md/) }
      files.each do |file|
        mkdir(folder_name(file), true)
        FileUtils.mv("#{mydir}/#{file}", "#{mydir}/#{folder_name(file)}/#{file}")
        puts "#{file} -> #{folder_name(file)}/#{file}"
      end
    end

    def self.upload
      commit_msg = Date.today.strftime('Update logfile(s) at %Y/%m/%d')
      if system('git pull')
        system('git add -A')
        if system("git commit -m '#{commit_msg}'")
          system('git push origin master')
        end
      end
    end

    def self.folder_name(filename)
      "20#{filename[0, 2]}-#{filename[2, 2]}" if filename.match(/^\d*\w*.md/)
    end

    def self.mkdir(name = nil, mute = false)
      foldername = if name.nil?
                      Date.today.strftime('%Y-%m')
                    else
                      name
                    end

      begin
        Dir.mkdir(foldername)
        puts("Folder #{foldername} is created.") unless mute
      rescue Errno::EEXIST
        puts("Eiya! Folder #{foldername} exists.") unless mute
      end
    end
  end
end
