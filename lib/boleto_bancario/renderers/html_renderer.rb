# encoding: utf-8
module BoletoBancario
  module Renderers
    module HTMLRenderer

      def self.render(boleto=nil)
        return "Nenhum boleto foi passado" unless boleto
        @boleto = boleto
        template_file = File.open("./lib/#{boleto.to_partial_path}.erb", 'r').read
        template = ERB.new(template_file)
        template.result(binding)
      end

    end
  end
end