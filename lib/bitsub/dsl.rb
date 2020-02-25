module BitSub
  class DSL
    attr_reader :base_dir, :subs, :feeds, :settings

    def initialize
      @base_dir = Dir.home
      @subs = []
      @feeds = []
      @settings = {
        output_fmt: lambda { |res| res[:link] },
        output_sep: "\n",
        reject: ->(t){ false }
      }
    end

    def reject(r)
      case r
      when Proc
        setting(reject: r)
      when :downloaded
        setting(reject: lambda { |t| t[:downloaded] })
      else
        raise "Invalid filter"
      end
    end

    def dir(dir)
      @base_dir = dir
    end

    def sub(dir, pat)
      @subs << { pat: pat, dir: dir }
    end

    def feed(uri)
      @feeds << uri
    end

    def nyaa(title, subgroup, res: '720')
      keyword = title.split.first.downcase

      sub(title, /#{subgroup}.*#{keyword}.*#{res}/i)
      feed("https://nyaa.si/?page=rss&c=1_2&f=1&q=#{subgroup}+#{keyword}")
    end

    def output(type)
      case type
      when :transmission
        setting(output_fmt: lambda do |t|
          ['--add', t[:link], '--download-dir', t[:download_dir]].join("\0")
        end)

        setting(output_sep: "\0")
      when :pretty
        setting(output_fmt: lambda do |t|
          sprintf(
            "%s - \e[%dm%s\e[0m",
            t[:date].strftime("%y.%m.%d"),
            t[:downloaded] ? 32 : 31,
            t[:title],
          )
        end)

        setting(output_sep: "\n")
      else
        raise "Unknown output type #{type}"
      end
    end

    def setting(hash)
      @settings.merge!(hash)
    end
  end
end
