# encoding: utf-8
require 'active_support/core_ext/object'

module BoletoBancario
  module Calculos
    # Representação numérica do código de barras, mais conhecida como linha digitável! :p
    #
    # A representação numérica do código de barras é composta, por cinco campos.
    # Sendo os três primeiros campos, amarrados por DAC's (dígitos verificadores),
    # todos calculados pelo módulo 10.
    #
    # <b>OBS.:</b> Para mais detalhes deste cálculo, veja a descrição em Modulo10.
    #
    # === Linha Digitável
    #
    # A linha digitável contêm exatamente 47 posições nessa sequência:
    #
    #       _____________________________________________________________________________________________________________
    #      |Campo | Posição  | Tamanho | Descrição                                                                      |
    #      |------|----------|---------|--------------------------------------------------------------------------------|
    #      | 1º   | 01-03    |  03     | Código do banco (posições 1 a 3 do código de barras)                           |
    #      |      | 04       |  01     | Código da moeda (posição 4 do código de barras)                                |
    #      |      | 05-09    |  5      | Cinco primeiras posições do campo livre (posições 20 a 24 do código de barras) |
    #      |      | 10       |  1      | Dígito verificador do primeiro campo (Módulo10)                                |
    #      |------------------------------------------------------------------------------------------------------------|
    #      | 2º   | 11-20    |  10     | 6º a 15º posições do campo livre (posições 25 a 34 do código de barras)        |
    #      |      | 21       |  01     | Dígito verificador do segundo campo  (Módulo10)                                |
    #      |------------------------------------------------------------------------------------------------------------|
    #      | 3º   | 22-31    |  10     | 16º a 25º posições do campo livre (posições 35 a 44 do código de barras)       |
    #      |      | 32       |  01     | Dígito verificador do terceiro campo  (Módulo10)                               |
    #      |------------------------------------------------------------------------------------------------------------|
    #      | 4º   | 33       |  01     | Dígito verificador do código de barras (posição 5 do código de barras)         |
    #      |------------------------------------------------------------------------------------------------------------|
    #      | 5ª   | 34-37    |  04     | Fator de vencimento (posições 6 a 9 do código de barras)                       |
    #      |      | 38-47    |  10     | Valor nominal do documento (posições 10 a 19 do código de barras)              |
    #      -------------------------------------------------------------------------------------------------------------|
    #
    # @return [String] Contêm a representação numérica do código de barras formatado com pontos e espaços.
    #
    # @example
    #
    #     LinhaDigitavel.new('34196166700000123451091234567880057123457000')
    #     # => '34191.09123 34567.880058 71234.570001 6 16670000012345'
    #
    #     LinhaDigitavel.new('99991101200000350007772130530150081897500000')
    #     # => '99997.77213 30530.150082 18975.000003 1 10120000035000'
    #
    #     LinhaDigitavel.new('39998100100000311551111122222500546666666001')
    #     # => '39991.11119 22222.500542 66666.660015 8 10010000031155'
    #
    class LinhaDigitavel < String
      attr_reader :codigo_de_barras
      # @param [String] codigo_de_barras Código de Barras de 44 posições
      # @return [String]
      #
      # Representação numérica do código de barras
      #
      # @example
      #
      #     LinhaDigitavel.new('34196166700000123451091234567880057123457000')
      #     # => '34191.09123 34567.880058 71234.570001 6 16670000012345'
      #
      #     LinhaDigitavel.new('99991101200000350007772130530150081897500000')
      #     # => '99997.77213 30530.150082 18975.000003 1 10120000035000'
      #
      #     LinhaDigitavel.new('39998100100000311551111122222500546666666001')
      #     # => '39991.11119 22222.500542 66666.660015 8 10010000031155'
      #
      #     # Retorna uma String vazia caso o código de barras esteja vazio.
      #     LinhaDigitavel.new('')
      #     # => ''
      #
      #     # Retorna uma String vazia caso o código de barras esteja vazio.
      #     LinhaDigitavel.new(nil)
      #     # => ''
      #
      #     # Retorna uma String vazia caso o código de barras seja menor que 44 posições.
      #     LinhaDigitavel.new('123456789')
      #     # => ''
      #
      #     # Retorna uma String vazia caso o código de barras seja maior que 44 posições.
      #     LinhaDigitavel.new('12345678901234567890123456789012345678901234567890')
      #     # => ''
      #
      def initialize(codigo_de_barras)
        @codigo_de_barras  = codigo_de_barras.to_s

        if @codigo_de_barras.present? and @codigo_de_barras.size == 44
          super(representacao_numerica_do_codigo_de_barras)
        else
          super('')
        end
      end

      # @return [String] Retorna todos os campos da linha digitável pegando as posições exatas do código de barras.
      #
      def representacao_numerica_do_codigo_de_barras
        "#{primeiro_campo} #{segundo_campo} #{terceiro_campo} #{quarto_campo} #{quinto_campo}"
      end

      # @api private
      #
      # Retorna o primeiro campo da linha digitável com seu respectivo dígito verificador.
      #
      # @return [String]
      #
      def primeiro_campo
        primeiro_campo_sem_digito = "#{codigo_de_barras[0..3]}#{codigo_de_barras[19..23]}"
        digito_verificador        = Modulo10.new(primeiro_campo_sem_digito)
        "#{primeiro_campo_sem_digito}#{digito_verificador}".gsub(/^(.{5})(.{5})/, '\1.\2')
      end

      # @api private
      #
      # Retorna o segundo campo da linha digitável com seu respectivo dígito verificador.
      #
      # @return [String]
      #
      def segundo_campo
        segundo_campo_sem_digito = "#{codigo_de_barras[24..33]}"
        digito_verificador       = Modulo10.new(segundo_campo_sem_digito)
        "#{segundo_campo_sem_digito}#{digito_verificador}".gsub(/(.{5})(.{6})/, '\1.\2')
      end

      # @api private
      #
      # Retorna o terceiro campo da linha digitável com seu respectivo dígito verificador.
      #
      # @return [String]
      #
      def terceiro_campo
        terceiro_campo_sem_digito = "#{codigo_de_barras[34..46]}"
        digito_verificador        = Modulo10.new(terceiro_campo_sem_digito)
        "#{terceiro_campo_sem_digito}#{digito_verificador}".gsub(/(.{5})(.{6})/, '\1.\2')
      end

      # @api private
      #
      # Retorna o dígito verificador do código de barras (posição 5 do código de barras)
      #
      # @return [String]
      #
      def quarto_campo
        "#{codigo_de_barras[4]}"
      end

      # @api private
      #
      # Retorna o quinto e último campo da linha digitável.
      #
      # @return [String]
      #
      def quinto_campo
        "#{codigo_de_barras[5..8]}#{codigo_de_barras[9..18]}"
      end
    end
  end
end