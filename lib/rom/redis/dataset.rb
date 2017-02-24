require 'rom/memory/dataset'

module ROM
  module Redis
    class Dataset
      attr_accessor :connection, :commands

      def initialize(connection, commands = [])
        @connection = connection
        @commands = commands
      end

      def to_a
        view
      end

      def each(&block)
        view.each(&block)
      end

      # override keys to scan over the key space and return an enumerator
      def keys(pattern = nil)
        Enumerator.new do |list|
          old_cursor, new_cursor = "0", nil
          while old_cursor != new_cursor do
            new_cursor, data = *scan(old_cursor, match: pattern).to_a.first
            data&.each { |d| list << d }
            old_cursor, new_cursor = new_cursor, old_cursor
          end
        end
      end

      def method_missing(command, *args)
        self.class.new(connection, commands.clone.push([command, args]))
      end

      private

      def view
        commands.map do |command, args|
          # So that the dataset can override redis commands
          if self.responds_to?(command)
            connection.send(command, *args)
          else
            send(comand, args)
          end
        end
      end
    end
  end
end
