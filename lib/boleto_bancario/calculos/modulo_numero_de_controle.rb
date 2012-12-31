module BoletoBancario
  module Calculos
    # === Cálculo do Módulo do Número de Controle (2 dígitos)
    #
    # Tipo de cálculo usado pelo Banco Banrisul.
    #
    # === Cálculo do Primeiro Dígito
    #
    # 1) Multiplica-se cada algarismo do campo pela seqüência de multiplicadores <b>2, 1, 2, 1, 2, 1 ...</b>, posicionados da direita para a esquerda.
    #
    # 2) Some individualmente, os algarismos dos resultados dos produtos, obtendo-se o total (N).
    #
    # 3) Divida o total encontrado (N) por 10, e determine o resto da divisão como MOD 10 (N).
    #
    # 4) Encontre o DAC através da seguinte expressão:
    #
    #    DAC = 10 - Mod 10 (n)
    #
    # === Cálculo do segundo dígito
    #
    # # 1) Tomando-se os algarismos multiplique-os, iniciando-se da direita para a esquerda,
    # pela seqüência numérica de 2 a 7 (2, 3, 4, 5, 6, 7 ... e assim por diante).
    #
    # 2) Some o resultado de cada produto efetuado e determine o total como (N).
    #
    # 3) Divida o total (N) por 11 e determine o resto obtido da divisão como Mod 11(N).
    #
    # 4) Calcule o dígito verificador (DAC) através da expressão:
    #
    #     DIGIT = 11 - Mod 11 (n)
    #
    # <b>Observações:</b>
    #
    # Caso o 'resto' obtido no cálculo do módulo '11' seja igual a '1', considera-se o DV inválido.
    # Soma-se, então, "1" ao DV obtido do módulo "10" e refaz-se o cálculo do módulo “11”.
    # Se o dígito obtido pelo módulo “10” era igual a "9", considera-se então (9+1=10) DV inválido.
    # Neste caso, o DV do módulo "10" automaticamente será igual a "0" e procede-se assim
    # novo cálculo pelo módulo "11".
    #
    # === Exemplo com Primeiro Dígito Inválido
    #
    # Dado o número '00009194':
    #
    # O somatório do primeiro cálculo é igual a '28' e o Resto é igual a '8'.
    # Portanto, o primeiro DV é igual a 10 - 8 ou DV = 2.
    #
    # O somatório do segundo cálculo é igual a '111' e o Resto é, neste caso, igual a '1'.
    # Portanto, o segundo DV é  inválido (11 - 1 = 10).
    #
    # Neste caso, soma-se '1' ao DV obtido do primeiro cálculo:
    #
    #      2 + 1
    #      # ======> 3 # Primeiro dígito do número de controle
    #
    # Agora, efetua-se novo cálculo do módulo 11, agora com o novo número, ou seja, 000091943:
    #
    # A somatório do segundo cálculo é igual a '113' e o Resto igual a '3'.
    # Portanto, o segundo DV é igual a:
    #
    #     11 - 3
    #     # ====> 8 # Segundo dígito do número de controle
    #
    # Neste exemplo, o número de controle será '38'.
    #
    class ModuloNumeroDeControle < String
      attr_reader :number, :first_digit, :second_digit

      def initialize(number)
        @number       = number
        @first_digit  = calculate_first_digit
        @second_digit = calculate_second_digit

        super(calculate)
      end

      # Retorna 2 dígitos verificando o segundo dígito se é válido ou não.
      #
      # @return [String]
      #
      def calculate
        if second_digit_result.equal?(10)
          @first_digit  = first_digit.to_i + 1
          @first_digit  = 0 if @first_digit.equal?(10)
          @second_digit = calculate_second_digit
        end

        "#{first_digit}#{second_digit}"
      end

      # Retorna a subtração de 11 pelo resto da divisão por 11 do segundo dígito.
      #
      # @return [Integer]
      #
      def second_digit_result
        11 - @second_digit.mod_division
      end

      # Calcula o primeiro dígito pelo módulo 10.
      # Para mais detalhes veja a classe Modulo10.
      #
      # @return [String]
      #
      def calculate_first_digit
        Modulo10.new(number)
      end

      # Calcula o segundo dígito pelo módulo 11 usando os fatores de 2 a 7.
      # Para mais detalhes veja a classe Modulo11FatorDe2a7.
      #
      # @return [String]
      #
      def calculate_second_digit
        Modulo11FatorDe2a7.new("#{number}#{first_digit}")
      end
    end
  end
end