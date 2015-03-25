# encoding: utf-8
module BoletoBancario
  module Core
    # Implementação de emissão de boleto bancário pelo Banco Real.
    #
    # === Documentação Implementada
    #
    # A documentação na qual essa implementação foi baseada está localizada na pasta
    # 'documentacoes_dos_boletos/real' dentro dessa biblioteca.
    #
    # Cobrança sem registro:
    #   Nosso número: 13 dígitos
    #   Código da Agência: 4 dígitos
    #   Número da Conta: 7 dígitos
    #
    # === Código da Carteira
    #
    #   '00' - Carteira do convênio
    #   '20' - Cobrança Simples
    #   '31' - Cobrança Câmbio
    #   '42' - Cobrança Caucionada
    #   '47' - Cobr. Caucionada Crédito Imobiliário
    #   '85' - Cobrança Partilhada
    #
    class Real < Boleto
      # Tamanho máximo de uma agência no Banco Real.
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
      # @return [Fixnum] 7
      #
      def self.tamanho_maximo_conta_corrente
        7
      end

      # Tamanho máximo do numero do documento no Boleto.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 13
      #
      def self.tamanho_maximo_numero_documento
        13
      end

      # <b>Carteiras suportadas.</b>
      #
      # <b>Método criado para validar se a carteira informada é suportada.</b>
      #
      # @return [Array]
      #
      def self.carteiras_suportadas
        %w[00 20 31 42 47 85]
      end

      # Validações para os campos abaixo:
      #
      # * Agencia
      # * Conta Corrente
      # * Número do documento
      #
      # Se você quiser sobrescrever os metodos, <b>ficará a sua responsabilidade.</b>
      # Basta você sobrescrever os métodos de validação:
      #
      #    class Real < BoletoBancario::Core::Real
      #       def self.tamanho_maximo_agencia
      #         6
      #       end
      #
      #       def self.tamanho_maximo_conta_corrente
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
      validates :agencia, :conta_corrente, presence: true

      validates :agencia,          length: { maximum: tamanho_maximo_agencia          }, if: :deve_validar_agencia?
      validates :conta_corrente,   length: { maximum: tamanho_maximo_conta_corrente   }, if: :deve_validar_conta_corrente?
      validates :numero_documento, length: { maximum: tamanho_maximo_numero_documento }, if: :deve_validar_numero_documento?

      validates :carteira, inclusion: { in: ->(object) { object.class.carteiras_suportadas } }, if: :deve_validar_carteira?

      # @return [String] 4 caracteres
      #
      def agencia
        @agencia.to_s.rjust(4, '0') if @agencia.present?
      end

      # @return [String] 7 caracteres
      #
      def conta_corrente
        @conta_corrente.to_s.rjust(7, '0') if @conta_corrente.present?
      end

      # @return [String] 13 caracteres
      #
      def numero_documento
        @numero_documento.to_s.rjust(13, '0') if @numero_documento.present?
      end

      # @return [String] 2 caracteres
      #
      def carteira
        @carteira.to_s.rjust(2, '0') if @carteira.present?
      end

      # @return [String] Código do Banco descrito na documentação.
      #
      def codigo_banco
        '356'
      end

      # @return [String] Dígito do código do banco descrito na documentação.
      #
      def digito_codigo_banco
        '5'
      end

      # Campo Agência/Código Cedente
      #
      # @return [String] Campo descrito na documentação.
      #
      def agencia_codigo_cedente
        "#{agencia}/#{conta_corrente}/#{cobranca_dv}"
      end

      # Cálculo do Digito verificador da Cobrança
      #   Nosso Número + Agência + Conta Corrente
      #   Calculado atravez do modulo 10
      #
      # @return [String]
      #
      def cobranca_dv
        Modulo10.new("#{nosso_numero}#{agencia}#{conta_corrente}")
      end

      # O nosso numero é o mesmo numero que o cliente informa para o numero do documento
      #
      # @return [String]
      #
      def nosso_numero
        "#{numero_documento}"
      end

      #  === Código de barras do banco
      #     ____________________________________________________
      #    | Posição | Tamanho | Descrição                      |
      #    |---------|---------|--------------------------------|
      #    | 20 – 23 |   04    | Agencia                        |
      #    | 24 – 30 |   07    | Conta corrente                 |
      #    | 31 – 31 |   01    | Digito verificador da cobrança |
      #    | 32 – 44 |   13    | Nosso numero                   |
      #    |____________________________________________________|
      #
      # @return [String]
      #
      def codigo_de_barras_do_banco
        "#{agencia}#{conta_corrente}#{cobranca_dv}#{nosso_numero}"
      end
    end
  end
end
