class HarbourCrane
  class Application
    class Container < Docker::Container

      def initialize
        infos = Util.parse_json(connection.get('/info'))
        infos.each do |name, value|
          send("#{name}=", value)
        end
      end

      def proxy?

      end


    end
  end
end
