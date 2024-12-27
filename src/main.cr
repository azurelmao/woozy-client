require "./client_actor"

module Crystal
  def self.main_user_code(argc : Int32, argv : UInt8**)
    begin
      previous_def
    rescue ex
      Log.fatal(exception: ex) { "" }
    end
  end
end

CrystGLFW.run do
  begin
    client_actor = Woozy::ClientActor.new
    client_actor.start
  rescue ex
    Log.fatal(exception: ex) { "" }

    if client_actor
      client_actor.stop
    end
  end
end
