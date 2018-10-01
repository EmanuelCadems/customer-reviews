class CurlParser
  def initialize(attributes, execute_after)
    @attributes = attributes
    @execute_after = execute_after
    @parsed_commands = []
  end

  def exec
    curl_cmds.each do |curl_cmd|
      @parsed_commands << parse(curl_cmd)
    end
    @parsed_commands
  end

  private

  def parse(curl_cmd)
    @attributes.each do |key, value|
      if value.kind_of?(ActiveSupport::TimeWithZone)
        curl_cmd.gsub!(":#{key}", value.iso8601(3))
      else
        curl_cmd.gsub!(":#{key}", value.to_s)
      end
    end

    curl_cmd
  end

  def curl_cmds
    all_services.pluck(:curl_cmd)
  end

  def all_services
    Service.send(@execute_after).or(Service.crud)
  end
end
