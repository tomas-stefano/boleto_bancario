module BoletoBancario
  module Core
    # Implementação de emissão de boleto bancário do Banrisul.
    #
    # === Documentação Implementada
    #
    # A documentação na qual essa implementação foi baseada está localizada na pasta
    # 'documentacoes_dos_boletos/banrisul' dentro dessa biblioteca.
    #
    # === Contrato das classes de emissão de boletos
    #
    # Para ver o "<b>contrato</b>" da Emissão de Boletos (geração de código de barras, linha digitável, etc) veja
    # a classe BoletoBancario::Core::Boleto.
    #
    # === Carteiras Suportadas
    #
    # 00 - CCB sem registro
    # 08 - CCB com registro
    #
    # === Usage
    #
    #    class BoletoBanrisul < BoletoBancario::Banrisul
    #    end
    #
    #    boleto = BoletoBanrisul.new do |boleto|
    #      boleto.numero_documento      = 22832563
    #      boleto.agencia               = 100
    #      boleto.data_vencimento       = Date.parse('2004-07-04')
    #      boleto.codigo_cedente        = "0000001"
    #      boleto.valor_documento       = 5.0
    #    end
    #
    class Banrisul < Boleto
      # Tamanho máximo de uma agência no Banrisul (sem número de controle).
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 3
      #
      def self.maximo_agencia
        3
      end

      # Tamanho máximo do código cedente.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 4
      #
      def self.maximo_codigo_cedente
        7
      end

      # Tamanho máximo do número do documento.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 8
      #
      def self.maximo_numero_documento
        8
      end

      # <b>Carteiras suportadas.</b>
      #
      # <b>Método criado para validar se a carteira informada é suportada.</b>
      #
      # @return [Array]
      #
      def self.carteiras_suportadas
        %w[00 08]
      end

      validates :agencia, :digito_agencia, :codigo_cedente, :digito_codigo_cedente, presence: true

      validates :agencia,               length: { maximum: maximo_agencia          }, if: :deve_validar_agencia?
      validates :codigo_cedente,        length: { maximum: maximo_codigo_cedente   }, if: :deve_validar_codigo_cedente?
      validates :numero_documento,      length: { maximum: maximo_numero_documento }, if: :deve_validar_numero_documento?

      validates :carteira, inclusion: { in: ->(object) { object.class.carteiras_suportadas } }, if: :deve_validar_carteira?

      # @return [String] 3 caracteres
      #
      def agencia
        @agencia.to_s.rjust(3, '0') if @agencia.present?
      end

      # @return [String] 8 caracteres
      #
      def numero_documento
        @numero_documento.to_s.rjust(8, '0') if @numero_documento.present?
      end

      # @return [String] 7 caracteres
      #
      def codigo_cedente
        @codigo_cedente.to_s.rjust(7, '0') if @codigo_cedente.present?
      end

      # @return [String] 2 caracteres
      #
      def carteira
        @carteira.to_s.rjust(2, '0') if @carteira.present?
      end

      # @return [String] Código do Banco descrito na documentação.
      #
      def codigo_banco
        '041'
      end

      # Dígito do código do banco. Precisa mostrar esse dígito no boleto.
      #
      # @return [String] Dígito do código do banco descrito na documentação.
      #
      def digito_codigo_banco
        '8'
      end

      # Dígito do código da agência. Precisa mostrar esse dígito no boleto.
      #
      # @return [String] Dígito da agência calculado apartir do ModuloNumeroDeControle.
      #
      def digito_agencia
        ModuloNumeroDeControle.new(agencia)
      end

      # Dígito do código do cedente. Precisa mostrar esse dígito no boleto.
      #
      # @return [String] Dígito do código do cedente calculado apartir do ModuloNumeroDeControle.
      #
      def digito_codigo_cedente
        ModuloNumeroDeControle.new(codigo_cedente)
      end

      # Retorna a Agencia, digito da agencia, código do cedente e o dígito do código do cedente.
      #
      # @return [String]
      #
      def agencia_codigo_cedente
        "#{agencia}.#{digito_agencia} #{codigo_cedente}.#{digito_codigo_cedente}"
      end

      # Retorna o número do documento com seu número de controle.
      #
      # Para mais detalhes do cálculo, veja a classe ModuloNumeroDeControle.
      #
      # @return [String]
      #
      def nosso_numero
        "#{numero_documento}.#{ModuloNumeroDeControle.new(numero_documento)}"
      end

      #  === Código de barras do banco
      #
      #     ________________________________________________________________________________________________
      #    | Posição | Tamanho | Descrição                                                                 |
      #    |---------|---------|---------------------------------------------------------------------------|
      #    | 20      |  01     | Tipo da cobrança do produto (mais detalhes veja #tipo_da_cobranca)        |
      #    | 21      |  01     | Constante '1'                                                             |
      #    | 22-24   |  03     | Agência (sem número de controle)                                          |
      #    | 25-31   |  07     | Código do Cedente (sem número de controle)                                |
      #    | 32-39   |  08     | Nosso número (número do documento sem número de controle)                 |
      #    | 40-42   |  03     | Constante '041'                                                           |
      #    | 43-44   |  02     | Duplo Dígito referente às posições 20 a 42 (módulo do numero de controle) |
      #    ------------------------------------------------------------------------------------------------|
      #
      def codigo_de_barras_do_banco
        codigo = "#{tipo_da_cobranca}1#{agencia}#{codigo_cedente}#{numero_documento}041"
        "#{codigo}#{ModuloNumeroDeControle.new(codigo)}"
      end

      # Tipo da cobranca do boleto
      #
      # "1" Cobrança Normal, Fichário emitido pelo BANRISUL.
      # "2" Cobrança Direta, Fichário emitido pelo CLIENTE.
      #
      # @return [String]
      #
      def tipo_da_cobranca
        "2"
      end
    end
  end
end