# frozen_string_literal: true

module BoletoBancario
  module Core
    # Implementação de emissão de boleto bancário pelo C6 Bank.
    #
    # === Documentação Implementada
    #
    # A documentação na qual essa implementação foi baseada está localizada na pasta
    # 'documentacoes_dos_boletos/c6_bank' dentro dessa biblioteca.
    #
    # === Contrato das classes de emissão de boletos
    #
    # Para ver o "<b>contrato</b>" da Emissão de Boletos veja a classe BoletoBancario::Core::Boleto.
    #
    # === Carteiras suportadas
    #
    # O C6 Bank trabalha com carteira de cobrança registrada.
    #
    #      ___________________________________________________________________________
    #     | Carteira | Descrição                           | Testada/Homologada     |
    #     |    1     | Cobrança Registrada                 | Esperando Contribuição |
    #     ----------------------------------------------------------------------------
    #
    class C6Bank < Boleto
      # Tamanho máximo de uma conta corrente no C6 Bank.
      #
      # @return [Integer] 10
      #
      def self.tamanho_maximo_conta_corrente
        10
      end

      # Tamanho máximo de uma agência no C6 Bank.
      #
      # @return [Integer] 4
      #
      def self.tamanho_maximo_agencia
        4
      end

      # Tamanho máximo do número do documento.
      #
      # @return [Integer] 11
      #
      def self.tamanho_maximo_numero_documento
        11
      end

      # Tamanho máximo do código do cedente.
      #
      # @return [Integer] 10
      #
      def self.tamanho_maximo_codigo_cedente
        10
      end

      # Carteiras suportadas pelo C6 Bank.
      #
      # @return [Array]
      #
      def self.carteiras_suportadas
        %w[1]
      end

      validates :agencia, :conta_corrente, presence: true
      validates :numero_documento, length: { maximum: tamanho_maximo_numero_documento }, if: :deve_validar_numero_documento?
      validates :conta_corrente, length: { maximum: tamanho_maximo_conta_corrente }, if: :deve_validar_conta_corrente?
      validates :agencia, length: { maximum: tamanho_maximo_agencia }, if: :deve_validar_agencia?
      validates :carteira, inclusion: { in: ->(object) { object.class.carteiras_suportadas } }, if: :deve_validar_carteira?

      # @return [String] Número do documento com 11 dígitos.
      #
      def numero_documento
        @numero_documento.to_s.rjust(11, '0') if @numero_documento.present?
      end

      # @return [String] Agência com 4 dígitos.
      #
      def agencia
        @agencia.to_s.rjust(4, '0') if @agencia.present?
      end

      # @return [String] Conta corrente com 10 dígitos.
      #
      def conta_corrente
        @conta_corrente.to_s.rjust(10, '0') if @conta_corrente.present?
      end

      # @return [String] Código do cedente com 10 dígitos.
      #
      def codigo_cedente
        @codigo_cedente.to_s.rjust(10, '0') if @codigo_cedente.present?
      end

      # Código do C6 Bank.
      #
      # @return [String] '336'
      #
      def codigo_banco
        '336'
      end

      # Dígito do código do banco.
      #
      # @return [String] '5'
      #
      def digito_codigo_banco
        '5'
      end

      # Dígito verificador da conta corrente.
      #
      # @return [String]
      #
      def digito_conta_corrente
        Modulo10.new(conta_corrente.to_s)
      end

      # Agência e código do cedente formatados.
      #
      # @return [String]
      #
      def agencia_codigo_cedente
        "#{agencia} / #{conta_corrente}-#{digito_conta_corrente}"
      end

      # Nosso Número formatado.
      #
      # @return [String]
      #
      def nosso_numero
        "#{numero_documento}-#{digito_nosso_numero}"
      end

      # Dígito verificador do nosso número.
      #
      # @return [String]
      #
      def digito_nosso_numero
        Modulo11FatorDe2a9.new(numero_documento.to_s)
      end

      # Segunda parte do código de barras (campo livre).
      # 25 posições específicas do C6 Bank.
      #
      # @return [String]
      #
      def codigo_de_barras_do_banco
        codigo = "#{agencia}#{carteira.to_s.rjust(1, '0')}#{numero_documento}#{conta_corrente.to_s[0, 9]}"
        "#{codigo.ljust(25, '0')}"
      end
    end
  end
end
