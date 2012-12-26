module BoletoBancario
  module Calculos
    # Classe responsável por calcular o módulo 11 com fatores de 2 a 9.
    # <b>Essa classe difere da outra com Modulo11FatorDe2a9, no momento de verificar o resto da divisão por 11.</b>
    #
    # <b>Para mais detalhes veja a classe Modulo11FatorDe2a9.</b>
    #
    class Modulo11FatorDe2a9RestoZero < Modulo11FatorDe2a9
      # Realiza o cálculo do módulo 11 com fatores de 2 a 9.
      #
      # === Resto Da divisão por 11
      #
      # * Se o resto da divisão por 11 for igual a 10, o digito será '1' (um),
      # * Se o resto da divisão por 11 for igual a 1 (um) ou 0 (zero) o digito será 0 (zero).
      #
      # Qualquer “RESTO” diferente de “0, 1 ou 10”, subtrair o resto de 11 para obter o digíto.
      #
      # @return [Fixnum] Resultado da subtração ou resultado da verificação do resto da divisão.
      #
      def calculate
        if mod_division.equal?(1) or mod_division.equal?(0)
          0
        else
          total
        end
      end
    end
  end
end