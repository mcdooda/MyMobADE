module Ade
  module Schools
    
    class Ujf < Ade::Config
      def initialize
        super
        @ade_path = 'http://ade52-ujf.grenet.fr/ade/'
      end
    end
    
  end
end
