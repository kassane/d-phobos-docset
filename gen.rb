require "nokogiri"

basedir = ARGV.shift
reldir = ARGV.shift
subpaths = ARGV

counter_regexp = /counter-reset: h1 (\d+)/
out = File.open("index.sql","w")
out.puts "CREATE TABLE IF NOT EXISTS searchIndex(id INTEGER PRIMARY KEY, name TEXT, type TEXT, path TEXT);"
out.puts "CREATE UNIQUE INDEX anchor ON searchIndex (name, type, path);"
subpaths.each do |subpathSpec|
  subpath, type = subpathSpec.split("/")
  Dir[File.join(basedir, subpath, "/*")].each do |f|
    puts "Working on #{f}"
    text = IO.read(f)
    m = text.match(counter_regexp)
    doc = Nokogiri::HTML(text)
    title = doc.at_css(".hyphenate > h1")
    next unless title
    page_name = title.text.gsub("'", "''")
    if m
      page_name = "#{m[1].rjust(2, '0')} - #{page_name}"
    end
    relpath = f[reldir.length+1..-1]
    out.puts "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('#{page_name}', '#{type}', '#{relpath}');"
    doc.css(".d_decl > div > span").each do |el|
      next unless el
      anchor = el["id"]
      next unless anchor
      next unless anchor.start_with?(".")
      name = anchor[1..-1]
      out.puts "INSERT OR IGNORE INTO searchIndex(name, type, path) VALUES ('#{name}', 'Function', '#{relpath}##{anchor}');"
    end
  end
end
