HOME = ENV["HOME"]
desc "Prepare from installed ~/dlang/dmd*"
task :prepare do
  mkdir_p "D.docset/Contents/Resources/Documents"
  sh "cp -R #{HOME}/dlang/dmd-*/html/d/ D.docset/Contents/Resources/Documents"
end

SQLITE_DB = "D.docset/Contents/Resources/docSet.dsidx"
desc "Gen sqlite index"
task :gen do
  ruby "gen.rb D.docset/Contents/Resources/Documents D.docset/Contents/Resources/Documents phobos/Module spec/Section articles/Word changelog/Tag"
  rm SQLITE_DB if File.exist?(SQLITE_DB)
  sh "sqlite3 #{SQLITE_DB} < index.sql"
end

desc "Clean"
task :clean do
  rm_rf "D.docset"
  sh "git restore D.docset"
end

desc "Install docset (for osx)"
task :install do
  cp_r "D.docset", "#{HOME}/Library/Application\ Support/Zeal/Zeal/docsets/"
end

task :default => [:clean, :prepare, :gen, :install]
