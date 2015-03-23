# encoding: utf-8
module BoletoBancario
  module Core
    # Implementação de emissão de boleto bancário pelo Banco Sicoob.
    #
    # === Documentação Implementada
    #
    # A documentação na qual essa implementação foi baseada está localizada na pasta
    # 'documentacoes_dos_boletos/sicoob' dentro dessa biblioteca.
    #
    class Sicoob < Boleto
      # Tamanho máximo de uma agência no Banco Sicoob.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 4
      #
      def self.tamanho_maximo_agencia
        4
      end

      # Tamanho máximo do codigo cedente no Banco Sicoob.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 7
      #
      def self.tamanho_maximo_codigo_cedente
        7
      end

      # Tamanho máximo do numero do documento no Boleto.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 6
      #
      def self.tamanho_maximo_numero_documento
        6
      end

      # Validações para os campos abaixo:
      #
      # * Agencia
      # * Codigo Cedente
      # * Número do documento
      #
      # Se você quiser sobrescrever os metodos, <b>ficará a sua responsabilidade.</b>
      # Basta você sobrescrever os métodos de validação:
      #
      #    class Sicoob < BoletoBancario::Core::Sicoob
      #       def self.tamanho_maximo_agencia
      #         6
      #       end
      #
      #       def self.tamanho_maximo_codigo_cedente
      #         9
      #       end
      #
      #       def self.tamanho_maximo_numero_documento
      #         10
      #       end
      #    end
      #
      # Obs.: Mudar as regras de validação podem influenciar na emissão do boleto em si.
      # Talvez você precise analisar o efeito no #codigo_de_barras e na #linha_digitável (ambos podem ser
      # sobreescritos também).
      #
      validates :agencia, :codigo_cedente, presence: true

      validates :agencia,          length: { maximum: tamanho_maximo_agencia          }, if: :deve_validar_agencia?
      validates :codigo_cedente,   length: { maximum: tamanho_maximo_codigo_cedente   }, if: :deve_validar_codigo_cedente?
      validates :numero_documento, length: { maximum: tamanho_maximo_numero_documento }, if: :deve_validar_numero_documento?

      # @return [String] 4 caracteres
      #
      def agencia
        @agencia.to_s.rjust(4, '0') if @agencia.present?
      end

      # @return [String] 7 caracteres
      #
      def codigo_cedente
        @codigo_cedente.to_s.rjust(7, '0') if @codigo_cedente.present?
      end

      # @return [String] 6 caracteres
      #
      def numero_documento
        @numero_documento.to_s.rjust(6, '0') if @numero_documento.present?
      end

      # Conforme descrito na documentação a carteira SEM registro é a numero 1.
      #
      # @return [String]
      #
      def carteira
        1
      end

      # @return [String] Código do Banco descrito na documentação.
      #
      def codigo_banco
        '756'
      end

      # @return [String] Dígito do código do banco descrito na documentação.
      #
      def digito_codigo_banco
        '0'
      end

      # Campo Agência / Código do Cedente
      #
      # @return [String]
      #
      def agencia_codigo_cedente
        "#{agencia} / #{codigo_cedente}"
      end

      # O nosso número descrino na documentação é formado pelo dois ultimos digitos do ano autal e
      # por outros 6 digitos que o clinte usara para numerar os documentos, assim sendo composto por 8 dígitos.
      #
      # @return [String]
      #
      def nosso_numero
        "#{ano}#{numero_documento}"
      end

      # Ano atual usado para os calculos
      #
      # @return [String]
      #
      def ano
        Date.today.strftime('%y')
      end

      #  === Código de barras do banco
      #
      #     ___________________________________________________________
      #    | Posição | Tamanho | Descrição                             |
      #    |---------|---------|---------------------------------------|
      #    | 20 - 20 |    01   | Código da carteira                    |
      #    | 21 - 24 |    04   | Código da agência                     |
      #    | 25 - 26 |    02   | Código da modalidade de cobrança (01) |
      #    | 27 - 33 |    07   | Código do Cedente                     |
      #    | 34 - 41 |    08   | Nosso Número do título                |
      #    | 42 - 44 |    03   | Número da Parcela do Título (001)     |
      #    |___________________________________________________________|
      #
      # @return [String]
      #
      def codigo_de_barras_do_banco
        "#{carteira}#{agencia}#{modalidade_cobranca}#{codigo_cedente}#{nosso_numero}#{parcelas}"
      end

      def modalidade_cobranca
        '01'
      end

      def parcelas
        '001'
      end
    end
  end
end
