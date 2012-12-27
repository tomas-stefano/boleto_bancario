# encoding: utf-8
module BoletoBancario
  module Calculos
    # Classe responsável por multiplicar cada dígito pelos fatores de multiplicação passado como argumento.
    #
    # Imagine que temos o número <b>'2468'</b> e os fatores de multiplicação <b>[2, 1]</b>.
    #
    # Será calculado da seguinte maneira:
    #
    #      2   4   6   8
    #      *   *   *   * ===> Multiplicação
    #      1   2   1   2
    #
    #      #=> [2,  8,  6,  16]
    #
    # Você pode passar outros fatores de multiplicação se você precisar.
    # Por exemplo, dado o número '1234567890' e os fatores de multiplicação: <b>[2, 3, 4, 5, 6, 7, 8, 9]</b>.
    # Será calculado da seguinte maneira:
    #
    #      1   2    3   4   5   6   7   8   9   0
    #      *   *    *   *   *   *   *   *   *   *
    #      3   2    9   8   7   6   5   4   3   2
    #
    #      #=> [3,  4,  27, 32, 35, 36, 35, 32, 27,  0]
    #
    # @param  [String] O número que será usado para multiplicar cada dígito.
    # @param [Hash] Os fatores de multiplicação que irão ser calculados na ordem reversa.
    #
    # @example Calculo
    #
    #    BoletoBancario::Calculos::FatoresDeMultiplicacao.new(123, fatores: [2, 1])
    #    # => [1, 2, 6]
    #
    #    BoletoBancario::Calculos::FatoresDeMultiplicacao.new(123, fatores: [2, 3, 4, 5, 6, 7, 8, 9])
    #    # => [4, 6, 6]
    #
    #    BoletoBancario::Calculos::FatoresDeMultiplicacao.new(809070608090, fatores: [9, 8, 7, 6, 5, 4, 3, 2])
    #    # => [48, 0, 72, 0, 14, 0, 24, 0, 48, 0, 72, 0]
    #
    class FatoresDeMultiplicacao < Array
      # @param [String || Integer] number
      # @param [Hash] options
      # @option options [Array] :fatores
      # @return [Array]
      # @example
      #
      #    FatoresDeMultiplicacao.new(12, fatores: [2, 1])
      #    # => [1, 4]
      #
      #    FatoresDeMultiplicacao.new(1864, fatores: [2, 3, 4, 5, 6, 7, 8, 9])
      #    # => [5, 32, 18, 8]
      #
      def initialize(number, options)
        @number  = number.to_s.reverse.split('')
        @factors = options.fetch(:fatores).cycle.take(@number.size)
        super(calculate)
      end

      # Para cada número realiza a multiplicação para cada dígito.
      # @return [Array]
      #
      def calculate
        @number.collect.each_with_index { |n, index| n.to_i * @factors[index] }.reverse
      end
    end
  end
end