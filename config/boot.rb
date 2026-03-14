ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

if Gem.win_platform?
  module WindowsAbsoluteGlobWorkaround
    module_function

    def apply(pattern, flags, sort:, kwargs: {})
      patterns = Array(pattern)
      return if patterns.empty?
      return unless patterns.any? { |item| absolute_glob?(item) }

      expanded = patterns.flat_map do |item|
        next [item] unless absolute_glob?(item)

        base, relative = split(item)
        next [item] unless base && relative

        Dir.__money_log_original_glob(relative, base: base, sort: sort).map do |entry|
          File.join(base, entry).tr("\\", "/")
        end
      end

      expanded
    end

    def sanitize(pattern, results)
      patterns = Array(pattern)
      wildcard_patterns = patterns.select { |item| item.is_a?(String) && item.match?(/[\*\?\[\{]/) }

      Array(results).reject do |entry|
        wildcard_patterns.include?(entry) && !File.exist?(entry)
      end
    end

    def absolute_glob?(pattern)
      pattern.is_a?(String) && pattern.match?(/\A[A-Za-z]:\//) && pattern.match?(/[\*\?\[\{]/)
    end

    def split(pattern)
      wildcard_index = pattern.index(/[\*\?\[\{]/)
      return unless wildcard_index

      base = File.dirname(pattern[0...wildcard_index])
      relative = pattern.delete_prefix("#{base}/")
      [base, relative]
    end
  end

  class << Dir
    alias_method :__money_log_original_glob, :glob

    def glob(pattern, *flags, base: nil, sort: true, **kwargs)
      if base.nil?
        expanded = WindowsAbsoluteGlobWorkaround.apply(pattern, flags, sort: sort, kwargs: kwargs)
        return expanded if expanded
      end

      result = __money_log_original_glob(pattern, *flags, base: base, sort: sort, **kwargs)
      WindowsAbsoluteGlobWorkaround.sanitize(pattern, result)
    end

    alias_method :[], :glob
  end
end

require "bundler/setup" # Set up gems listed in the Gemfile.

if Gem.win_platform?
  require "rake"

  class Rake::Application
    private

    def glob(path, &block)
      Dir.glob(path.tr("\\", "/")).sort.each(&block)
    end
  end
end

require "bootsnap/setup" # Speed up boot time by caching expensive operations.
