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
        reject: lambda { |t| t[:downloaded] }
      }
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

    def setting(hash)
      @settings.merge!(hash)
    end
  end
end
