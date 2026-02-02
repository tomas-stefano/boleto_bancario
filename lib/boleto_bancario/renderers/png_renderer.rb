# frozen_string_literal: true

require 'barby'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/png_outputter'

module BoletoBancario
  module Renderers
    # Renderizador de código de barras em formato PNG.
    #
    # Este renderizador gera apenas a imagem do código de barras,
    # não o boleto completo.
    #
    # @example Gerando um PNG do código de barras
    #
    #    boleto = BoletoBancario::Itau.new(...)
    #    png_content = BoletoBancario::Renderers::PngRenderer.new(boleto).render
    #    File.binwrite('barcode.png', png_content)
    #
    class PngRenderer < Base
      # Configurações padrão para o PNG.
      DEFAULT_OPTIONS = {
        height: 50,
        xdim: 2,
        margin: 10
      }.freeze

      attr_reader :options

      # Inicializa o renderizador com opções.
      #
      # @param [BoletoBancario::Core::Boleto] boleto O boleto
      # @param [Hash] options Opções para o PNG
      # @option options [Integer] :height Altura da barra (padrão: 50)
      # @option options [Integer] :xdim Largura de cada módulo (padrão: 2)
      # @option options [Integer] :margin Margem ao redor (padrão: 10)
      #
      def initialize(boleto, options = {})
        super(boleto)
        @options = DEFAULT_OPTIONS.merge(options)
      end

      # Renderiza o código de barras em PNG.
      #
      # @return [String] O conteúdo binário do PNG
      #
      def render
        barcode = Barby::Code25Interleaved.new(codigo_de_barras)
        outputter = Barby::PngOutputter.new(barcode)
        outputter.height = options[:height]
        outputter.xdim = options[:xdim]
        outputter.margin = options[:margin]
        outputter.to_png
      end

      # Renderiza e salva o código de barras em um arquivo.
      #
      # @param [String] filepath Caminho do arquivo
      # @return [Integer] Número de bytes escritos
      #
      def render_to_file(filepath)
        File.binwrite(filepath, render)
      end
    end
  end
end
