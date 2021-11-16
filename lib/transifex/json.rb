module Transifex
  module JSON
    class << self
      if MultiJson.respond_to?(:dump)
        def dump(*args)
          puts 'transifex::json'
          puts *args
          MultiJson.dump(*args)
        end

        def load(*args)
          puts 'transifex::json'
          puts *args
          MultiJson.load(*args)
        end
      else
        def dump(*args)
          puts 'transifex::json'
          puts *args
          MultiJson.encode(*args)
        end

        def load(*args)
          puts 'transifex::json'
          puts *args
          MultiJson.decode(*args)
        end
      end
    end
  end
end
