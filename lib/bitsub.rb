require 'rss'
require 'open-uri'
require 'bitsub/version'

module BitSub
  module_function

  def make_sub(pat, *dir)
    { pat: pat, dir: File.join(*dir) }
  end

  def find_all(subs)
    lambda do |feed|
      subs.map do |s|
        find(feed, s[:pat]).map do |item|
          {
            title: item.title.strip,
            link: item.link.strip,
            date: item.pubDate,
            desc: item.description&.strip || '',
            source: item.source,
            comments: item.comments,
            author: item.author,
            category: item.category,
            download_dir: s[:dir],
            file:  File.join(s[:dir], item.title.strip),
            downloaded: File.exist?(File.join(s[:dir], item.title.strip))
          }
        end
      end.flatten
    end
  end

  def find(rss, pat)
    rss.items.select { |item| pat.match?(item.title) }
  end

  def feed(uri)
    open(uri, 'r') { |f| RSS::Parser.parse(f) }
  end
end
