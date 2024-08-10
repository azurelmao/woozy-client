require "./woozy/client"

begin
  # raise "Mismatched number of arguments" if ARGV.size.odd?
  #
  # index = 0
  # while index < ARGV.size
  #   case ARGV[index]
  #   when "-u", "--username"
  #     username = ARGV[index + 1]
  #   end
  #   index += 2
  # end

  woozy_client = Woozy::Client.new
  woozy_client.start
rescue ex
  Log.fatal(exception: ex) { "" }
  if woozy_client
    woozy_client.stop
  end
end
