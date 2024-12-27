require "./sprite"
require "./block_impl"

class Woozy::Content
  getter sprites : Sprites
  getter blocks : Blocks

  def initialize
    @sprites = Sprites.new
    @blocks = Blocks.new(@sprites)
  end
end
