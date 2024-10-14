desc "Download"
task :download do
  sh "wget --recursive --page-requisites --html-extension --convert-links --restrict-file-names=windows --domains dlang.org --no-parent http://dlang.org/documentation.html || true"
  mkdir_p "D.docset/Contents/Resources/"
  mv "dlang.org", "D.docset/Contents/Resources/Documents"
end

SQLITE_DB = "D.docset/Contents/Resources/docSet.dsidx"
desc "Gen sqlite index"
task :gen do
  ruby "gen.rb D.docset/Contents/Resources/Documents D.docset/Contents/Resources/Documents phobos/Module spec/Section articles/Word changelog/Tag"
  rm SQLITE_DB if File.exist?(SQLITE_DB)
  sh "sqlite3 #{SQLITE_DB} < index.sql"
end

#desc "Clean"
#task :clean do
#  rm_rf "D.docset"
#  sh "git restore D.docset"
#end

desc "Archive"
task :archive do
  sh "tar --exclude='.DS_Store' -cvzf D.tgz D.docset"
  sh "zip -r D.docset.zip D.docset"
end

desc "Clean"
task :clean do
  rm_r "D.docset/Contents/Resources/Documents"
end

#task :default => [:clean, :prepare, :gen, :install]
