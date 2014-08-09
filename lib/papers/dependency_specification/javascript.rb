module Papers
  class Javascript < DependencySpecification
    def pretty_hash
      {
        name: @name,
        license: license,
        license_url: @license_url,
        project_url: @project_url
      }
    end

    def self.introspected
      dirs = Papers.config.javascript_paths
      whitelist_dirs = Papers.config.whitelist_javascript_paths

      # TODO: add logic for determining rails. Is Rails.root better than Dir.pwd for such a case?
      root_regexp = /^#{Regexp.escape Dir.pwd.to_s}\//
      files = dirs.map { |dir| Dir.glob("#{dir}/**/*.{js,coffee}") }.flatten.map do |name|
        name = name.sub(root_regexp, '')

        unless whitelist_dirs.empty?
          should_exclude = whitelist_dirs.any? do |whitelist_dir|
            name.start_with?(whitelist_dir)
          end
          name unless should_exclude
        else
          name
        end
      end

      files.compact
    end

    def self.manifest_key
      "javascripts"
    end
  end
end
