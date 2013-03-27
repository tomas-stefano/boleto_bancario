# encoding: utf-8
require 'barby'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/png_outputter'
require 'pry'

module BoletoBancario
  module Renderers
    module HTMLRenderer

      def self.render(boleto=nil)
        return "Nenhum boleto foi passado" unless boleto
        @boleto = boleto
        template = ERB.new(self.template_file)
        template.result(binding)
      end

      protected

        def self.template_file
          File.open(File.expand_path("./lib/#{@boleto.to_partial_path}.html.erb"), 'r').read
        end
    end
  end
end