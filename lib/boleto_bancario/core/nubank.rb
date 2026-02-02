# frozen_string_literal: true

module BoletoBancario
  module Core
    # Implementação de emissão de boleto bancário pelo Nubank.
    #
    # === Documentação Implementada
    #
    # A documentação na qual essa implementação foi baseada está localizada na pasta
    # 'documentacoes_dos_boletos/nubank' dentro dessa biblioteca.
    #
    # === Contrato das classes de emissão de boletos
    #
    # Para ver o "<b>contrato</b>" da Emissão de Boletos veja a classe BoletoBancario::Core::Boleto.
    #
    # === Carteiras suportadas
    #
    # O Nubank trabalha com carteira única de cobrança registrada.
    #
    #      ___________________________________________________________________________
    #     | Carteira | Descrição                           | Testada/Homologada     |
    #     |    1     | Cobrança Registrada                 | Esperando Contribuição |
    #     ----------------------------------------------------------------------------
    #
    class Nubank < Boleto
      # Tamanho máximo de uma conta corrente no Nubank.
      #
      # @return [Integer] 10
      #
      def self.tamanho_maximo_conta_corrente
        10
      end

      # Tamanho máximo de uma agência no Nubank.
      # Nubank utiliza agência fixa 0001.
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

      # Carteiras suportadas pelo Nubank.
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

      # Código do Banco Nubank.
      #
      # @return [String] '260'
      #
      def codigo_banco
        '260'
      end

      # Dígito do código do banco.
      #
      # @return [String] '0'
      #
      def digito_codigo_banco
        '0'
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
        "#{carteira}/#{numero_documento}-#{digito_nosso_numero}"
      end

      # Dígito verificador do nosso número.
      #
      # @return [String]
      #
      def digito_nosso_numero
        Modulo10.new("#{carteira}#{numero_documento}")
      end

      # Segunda parte do código de barras (campo livre).
      # 25 posições específicas do Nubank.
      #
      # @return [String]
      #
      def codigo_de_barras_do_banco
        codigo = "#{carteira.to_s.rjust(1, '0')}#{numero_documento}#{agencia}#{conta_corrente.to_s[0, 9]}"
        "#{codigo.ljust(25, '0')}"
      end
    end
  end
end
