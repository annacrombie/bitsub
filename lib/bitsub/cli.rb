module BitSub
  module CLI
    CFG_DIR = 'bitsub'
    CFG_NAME = 'profile.rb'

    PATHS = [
      Dir.pwd,
      File.join(
        ENV['XDG_CONFIG_HOME'] || File.join(
          Dir.home || Dir.pwd,
          '.config'
        ),
        CFG_DIR
      )
    ].map { |pth| File.join(pth, CFG_NAME) }

    module_function

    def build_profile(source)
      BitSub::DSL.new.tap do |dsl|
        dsl.instance_eval(File.read(source))
      end
    rescue Exception => e
      $stderr.puts("Error loading user profile at #{source}")
      raise e
    end

    def find_source
      PATHS.detect { |pth| File.exists?(pth) }
    end

    def main
      source = find_source
      if source.nil?
        $stderr.puts(<<~ERR)
          no #{CFG_NAME} found in paths

          list of paths searched:
          #{PATHS.join("\n")}
        ERR
        exit 1
      end

      print(sub!(build_profile(source)))
    end

    def sub!(profile)
      subs = profile.subs.map do |sub|
        BitSub.make_sub(sub[:pat], profile.base_dir, sub[:dir])
      end.tap { |ss| ss.each { |s| FileUtils.mkdir_p(s[:dir]) } }

      feeds = profile.feeds
      find = BitSub.find_all(subs)
      found = Queue.new
      feeds.map do |f|
        Thread.new { found.push(find.(BitSub.feed(f))) }
      end.each(&:join)

      results = []
      results += found.pop.flatten until found.empty?

      results.reject(&profile.settings[:reject])
             .map(&profile.settings[:output_fmt])
             .join(profile.settings[:output_sep])
    end
  end
end
