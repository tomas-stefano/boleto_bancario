# encoding: utf-8
module BoletoBancario
  module Renderers
    module HTMLRenderer

      def render(boleto)
        return "Nenhum boleto foi passado" unless boleto
        @boleto = boleto
        template_file = File.open('./lib/boleto_bancario/views/santander.erb', 'r').read
        template = ERB.new(template_file)
        template.result(binding)
      end

    end
  end
end