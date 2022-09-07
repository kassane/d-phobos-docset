require "nokogiri"

basedir = ARGV.shift
reldir = ARGV.shift

out = File.open("index.sql","w")
out.puts "CREATE TABLE IF NOT EXISTS searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"
out.puts "CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);"
Dir[File.join(basedir,"*")].each do |f|
  puts "Working on #{f}"
  doc = Nokogiri::HTML(IO.read(f))
  title = doc.at_css(".hyphenate > h1")
  next unless title
  page_name = title.text
  relpath = f[reldir.length+1..-1]
  out.puts "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('#{page_name}', 'Module', '#{relpath}');"
    doc.css(".d_decl > div > span").each do |el|
    next unless el
    anchor = el["id"]
    next unless anchor
    next unless anchor.start_with?(".")
    name = anchor[1..-1]
    out.puts "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('#{name}', 'Function', '#{relpath}##{anchor}');"
  end
end
