module Ade
  module Schools
  
    class Imag < Ade::Schools::Ujf
      def initialize
        super
        @login = 'voirIMA'
        @password = 'ima'
        @project = 'UFR_IMAG 2011-2012'
        self << 'Etudiants'
      end
    end
  
  end
end
