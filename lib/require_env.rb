require 'require_env/missing'
require 'safe_yaml/load'
require 'erb'

module RequireEnv
  def self.check(*files)
    check_multiple_requirements(files.map do |file|
      requirements = requirements_from_file(file)[application_environment]
      if requirements.nil?
        raise ArgumentError.new("#{file} does not define anything for environment: #{application_environment}")
      end
      [file, requirements]
    end)
  end

  def self.requirements_from_file(file)
    if File.exist?(file)
      SafeYAML.load(ERB.new(File.read(file)).result)
    else
      raise ArgumentError.new("File not found: #{file}")
    end
  end

  def self.check_multiple_requirements(multiple_requirements)
    missing_requirements = multiple_requirements.map do |file, requirements|
      missing = check_requirements(requirements)
      if missing.present?
        [file, missing]
      end
    end.compact

    if missing_requirements.present?
      raise RequireEnv::Missing.new(missing_requirements)
    end
  end

  def self.check_requirements(requirements)
    requirements.map do |key, value|
      if ENV.has_key?(key) || ENV.has_key?(key.split('_IF_').first)
        next nil
      elsif value
        ENV[key] = value.to_s
        next nil
      elsif key.include?('_IF_')
        if (condition = ENV[key.split('_IF_').last]) && condition != 'false'
          next key.split('_IF_').first
        end
      else
        next key
      end
    end.compact
  end

  def self.application_environment
    ENV['RAILS_ENV']
  end
end
