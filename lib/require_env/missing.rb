module RequireEnv
  class Missing < StandardError
    def initialize(requirements)
      message = "Missing environment variables!\n"
      requirements.each do |file, reqs|
        message += "- Declared in `#{file}':\n"
        message += reqs.map{|env| "\t- #{env}"}.join("\n")
        message += "\n"
      end
      super(message)
    end
  end
end
