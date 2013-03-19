# encoding: utf-8
require 'barby'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/png_outputter'

module BoletoBancario
  module Renderers
    module HTMLRenderer

      def self.render(boleto=nil)
        return "Nenhum boleto foi passado" unless boleto
        @boleto = boleto
        template_file = File.open("./lib/#{boleto.to_partial_path}.html.erb", 'r').read
        template = ERB.new(template_file)
        template.result(binding)
      end

    end
  end
end