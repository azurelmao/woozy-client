require "stumpy_png"

class Woozy::SpriteRegistry
  def initialize
    @current_index = 0_u32
    @index_to_sprite = Array(Sprite).new
  end

  def register(sprite : Sprite) : SpriteIdx
    index = @current_index
    @index_to_sprite << sprite
    @current_index += 1_u32
    index
  end

  def to_a : Array(Sprite)
    @index_to_sprite
  end
end

alias Woozy::SpriteIdx = UInt32

class Woozy::Sprites
  getter registry : SpriteRegistry
  getter stone : SpriteIdx
  getter dirt : SpriteIdx
  getter grass_top : SpriteIdx
  getter grass_side : SpriteIdx

  def initialize
    @registry = SpriteRegistry.new

    @stone = @registry.register Sprite.new("stone.png")
    @dirt = @registry.register Sprite.new("dirt.png")
    @grass_top = @registry.register Sprite.new("grass_top.png")
    @grass_side = @registry.register Sprite.new("grass_side.png")
  end

  delegate to_a, to: @registry
end

struct Woozy::Sprite
  def initialize(@path : String)
  end

  def load : StumpyPNG::Canvas
    StumpyPNG.read(IO::Memory.new(File.read(@path).to_slice))
  end
end
