require 'redis/namespace'
require 'rom/relation'
require 'rom/plugins/relation/key_inference'

module ROM
  module Redis
    class Relation < ROM::Relation
      include Enumerable

      adapter :redis
      use :key_inference

      forward(*::Redis::Namespace::COMMANDS.keys.map(&:to_sym))
    end
  end
end
