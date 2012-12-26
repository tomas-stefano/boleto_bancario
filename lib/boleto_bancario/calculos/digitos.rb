# encoding: utf-8
require 'active_support/core_ext/enumerable'

module BoletoBancario
  module Calculos
    # Classe responsável por lidar com os dígitos dos módulos.
    #
    class Digitos
      # @param [Integer] number Número que servirá para os cálculo com os dígitos desse número.
      #
      def initialize(number)
        @number = number
      end

      # Soma cada dígito do número passado no #initialize.
      # Alguns bancos requerem esse tipo estranho de cálculo em alguns módulos.
      # @return [Fixnum] Resultado da soma de cada dígito.
      #
      # @example
      #
      #    Digitos.new(12).sum
      #    # => 3
      #
      #    Digitos.new(2244).sum
      #    # => 12
      #
      #    Digitos.new(90123451).sum
      #    # => 25
      #
      def sum
        @number.to_s.split('').collect { |number| number.to_i }.sum
      end
    end
  end
end