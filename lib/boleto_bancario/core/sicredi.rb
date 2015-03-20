# encoding: utf-8
module BoletoBancario
  module Core
    # Implementação de emissão de boleto bancário pela Cooperativa de Credito Sicredi.
    #
    # === Documentação Implementada
    #
    # A documentação na qual essa implementação foi baseada está localizada na pasta
    # 'documentacoes_dos_boletos/sicredi' dentro dessa biblioteca.
    # === Carteiras suportadas
    #
    # Segue abaixo as carteiras suportadas pelo Sicredi <b>seguindo a documentação</b>:
    #
    #      __________________________________________
    #     | Carteira | Descrição                     |
    #     |    11    | Cobrança Simples com registro |
    #     |    31    | Cobrança Simples sem registro |
    #     |__________________________________________|
    #
    class Sicredi < Boleto
      # Código do posto da cooperativa de crédito
      attr_accessor :posto

      # Byte de identificação do cedente do bloqueto utilizado para compor o nosso número.
      attr_accessor :byte_id

      # Tamanho máximo de uma agência no Sicredi.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 4
      #
      def self.tamanho_maximo_agencia
        4
      end

      # Tamanho máximo da conta corrente no Boleto.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 5
      #
      def self.tamanho_maximo_conta_corrente
        5
      end

      # Tamanho máximo do posto no Boleto.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 2
      #
      def self.tamanho_maximo_posto
        2
      end

      # <b>Byte Identificadores suportados.</b>
      # <b>Método criado para validar se o byte identificador informado é suportado.</b>
      #
      # @return [Array]
      #
      def self.byte_id_suportados
        %w[2 3 4 5 6 7 8 9]
      end

      # <b>Carteiras suportadas.</b>
      # <b>Método criado para validar se a carteira informada é suportada.</b>
      #
      # @return [Array]
      #
      def self.carteiras_suportadas
        %w[11 31]
      end

      # Tamanho máximo do número do documento emitido no Boleto.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 5
      #
      def self.tamanho_maximo_numero_documento
        5
      end

      # Validações para os campos abaixo:
      #
      # * Agencia
      # * Conta Corrente
      # * Posto
      # * Byte Identificador
      # * Carteira
      # * Número do documento
      #
      # Se você quiser sobrescrever os metodos, <b>ficará a sua responsabilidade.</b>
      # Basta você sobrescrever os métodos de validação:
      #
      #    class Sicredi < BoletoBancario::Core::Sicredi
      #       def self.tamanho_maximo_agencia
      #         5
      #       end
      #
      #       def self.tamanho_maximo_conta_corrente
      #         7
      #       end
      #
      #       def self.tamanho_maximo_posto
      #         2
      #       end
      #
      #       def self.byte_id_suportados
      #         %w[1 12 123]
      #       end
      #
      #       def self.carteiras_suportadas
      #         %w[45 89]
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
      validates :agencia, :conta_corrente, :posto, :byte_id, presence: true

      validates :agencia,          length: { maximum: tamanho_maximo_agencia          }, if: :deve_validar_agencia?
      validates :conta_corrente,   length: { maximum: tamanho_maximo_conta_corrente   }, if: :deve_validar_conta_corrente?
      validates :posto,            length: { maximum: tamanho_maximo_posto            }, if: :deve_validar_posto?
      validates :numero_documento, length: { maximum: tamanho_maximo_numero_documento }, if: :deve_validar_numero_documento?

      validates :carteira, inclusion: { in: ->(object) { object.class.carteiras_suportadas } }, if: :deve_validar_carteira?
      validates :byte_id,  inclusion: { in: ->(object) { object.class.byte_id_suportados   } }, if: :deve_validar_byte_id?

      # @return [String] 4 caracteres
      #
      def agencia
        @agencia.to_s.rjust(4, '0') if @agencia.present?
      end

      # @return [String] 5 caracteres
      #
      def conta_corrente
        @conta_corrente.to_s.rjust(5, '0') if @conta_corrente.present?
      end

      # @return [String] 2 caracteres
      #
      def posto
        @posto.to_s.rjust(2, '0') if @posto.present?
      end

      # @return [String] 1 caracteres
      #
      def byte_id
        @byte_id.to_s.rjust(1, '0') if @byte_id.present?
      end

      # @return [String] 5 caracteres
      #
      def numero_documento
        @numero_documento.to_s.rjust(5, '0') if @numero_documento.present?
      end

      # A formatação da Carteira Simples é 1
      #
      # @return [String]
      #
      def carteira_formatada
        '1'
      end

      # @return [String] Código do Banco descrito na documentação.
      #
      def codigo_banco
        '748'
      end

      # @return [String] Dígito do código do banco descrito na documentação.
      #
      def digito_codigo_banco
        'X'
      end

      # Campo Agência/Código Beneficiário (:conta_corrente) formatado
      #
      # @return [String] Campo descrito na documentação.
      #
      def agencia_codigo_cedente
        "#{agencia}.#{posto}.#{conta_corrente}"
      end

      # Mostra o campo nosso número calculando o dígito verificador do nosso número. AA/BXXXXX-D onde:
      #   AA = Ano atual, apenas os dois ultimos digitos.
      #   B = Byte Identificador (2 a 9). 1 só poderá ser utilizado pela cooperativa.
      #   XXXXX – Número do Documento.
      #   D = Digito Verificador pelo módulo 11.
      #
      # EX: 13/200004-1
      #
      # @return [String]
      #
      def nosso_numero
        "#{ano}/#{byte_id}#{numero_documento}-#{nosso_numero_dv}"
      end

      # Ano atual usado para os calculos
      #
      # @return [String]
      #
      def ano
        Date.today.strftime('%y')
      end

      # Digito verificador do nosso número
      # Calculado atravez do modulo 11 com peso de 2 a 9 da direta para a esquerda.
      #            __________________________________________________________________
      #  _________| Agencia | Posto | Conta Corrente | Ano | Byte | Numero Documento |
      # | Tamanho |    04   |   02  |       05       |  02 |  01  |        05        |
      # |_________|__________________________________________________________________|
      #
      # @return [String]
      #
      def nosso_numero_dv
        Modulo11FatorDe2a9RestoZero.new("#{agencia}#{posto}#{conta_corrente}#{ano}#{byte_id}#{numero_documento}")
      end

      #  === Código de barras do banco
      #     __________________________________________________________________________
      #    | Posição | Tamanho | Descrição                                            |
      #    |---------|---------|------------------------------------------------------|
      #    | 20 – 21 |   02    | Carteira                                             |
      #    | 22 – 30 |   09    | Nosso número com o digito identificador              |
      #    | 31 – 34 |   04    | Cooperativa de crédito/agência beneficiária          |
      #    | 35 – 36 |   02    | Posto da cooperativa de crédito/agência beneficiária |
      #    | 37 – 41 |   05    | Código do beneficiário                               |
      #    | 42 – 42 |   01    | Será 1 quando houver o valor do documento            |
      #    | 43 – 43 |   01    | Fixo 0                                               |
      #    | 44 – 44 |   01    | DV do campo livre                                    |
      #    |__________________________________________________________________________|
      #
      # @return [String]
      #
      def codigo_de_barras_do_banco
        codigo = "#{carteira}#{nosso_numero_codigo_de_barras}#{agencia}#{posto}#{conta_corrente}#{valor_expresso}0"

        codigo_dv = Modulo11FatorDe2a9RestoZero.new(codigo)

        "#{codigo}#{codigo_dv}"
      end

      def nosso_numero_codigo_de_barras
        "#{ano}#{byte_id}#{numero_documento}#{nosso_numero_dv}"
      end

      def valor_expresso
        @valor_documento.present? ? '1' : '0'
      end

      # Método usado para verificar se deve realizar a validação de tamanho do campo 'posto'.
      # <b>Sobrescreva esse método na subclasse, caso você mesmo queira fazer as validações</b>.
      #
      # @return [True]
      #
      def deve_validar_posto?
        true
      end

      # Método usado para verificar se deve realizar a validação de tamanho do campo 'byte_id'.
      # <b>Sobrescreva esse método na subclasse, caso você mesmo queira fazer as validações</b>.
      #
      # @return [True]
      #
      def deve_validar_byte_id?
        true
      end
    end
  end
end
