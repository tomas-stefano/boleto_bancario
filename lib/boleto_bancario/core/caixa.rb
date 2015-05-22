# encoding: utf-8
module BoletoBancario
  module Core
    # Implementação de emissão de boleto bancário pela Caixa Econômica Federal.
    #
    # === Documentação Implementada
    #
    # A documentação na qual essa implementação foi baseada está localizada na pasta
    # 'documentacoes_dos_boletos/caixa' dentro dessa biblioteca.
    # === Carteiras suportadas
    #
    # Segue abaixo as carteiras suportadas da Caixa Econômica Federal <b>seguindo a documentação</b>:
    #
    #      _________________________________________________________________________
    #     | Carteira | Descrição                     | Testada/Homologada no banco  |
    #     |    14    | Cobrança Simples com registro | Esperando Contribuição       |
    #     |    24    | Cobrança Simples sem registro | Esperando Contribuição       |
    #     |_________________________________________________________________________|
    #
    class Caixa < Boleto
      # Tamanho máximo de uma agência na Caixa Econômica Federal.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 4
      #
      def self.tamanho_maximo_agencia
        4
      end

      # Tamanho máximo do código do cedente emitido no Boleto.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 6
      #
      def self.tamanho_maximo_codigo_cedente
        6
      end

      # <b>Carteiras suportadas.</b>
      # <b>Método criado para validar se a carteira informada é suportada.</b>
      #
      # @return [Array]
      #
      def self.carteiras_suportadas
        %w[14 24]
      end

      # Tamanho máximo do número do documento emitido no Boleto.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 15
      #
      def self.tamanho_maximo_numero_documento
        15
      end

      # Tamanho maximo do valor do documento do boleto.
      # O valor maximo descrito na decumentação é de 9999999.99
      #
      # @return [Float] 9999999.99
      #
      def self.valor_documento_tamanho_maximo
        9999999.99
      end

      # Validações para os campos abaixo:
      #
      # * Agencia
      # * Conta Corrente
      # * Carteira
      # * Número do documento
      #
      # Se você quiser sobrescrever os metodos, <b>ficará a sua responsabilidade.</b>
      # Basta você sobrescrever os métodos de validação:
      #
      #    class Santander < BoletoBancario::Core::Santander
      #       def self.tamanho_maximo_agencia
      #         5
      #       end
      #
      #       def self.tamanho_maximo_codigo_cedente
      #         7
      #       end
      #
      #       def self.tamanho_maximo_numero_documento
      #         10
      #       end
      #
      #       def self.carteiras_suportadas
      #         %w[10 53]
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

      validates :carteira, inclusion: { in: ->(object) { object.class.carteiras_suportadas } }, if: :deve_validar_carteira?

      # @return [String] 4 caracteres
      #
      def agencia
        @agencia.to_s.rjust(4, '0') if @agencia.present?
      end

      # @return [String] 6 caracteres
      #
      def codigo_cedente
        @codigo_cedente.to_s.rjust(6, '0') if @codigo_cedente.present?
      end

      # @return [String] 15 caracteres
      #
      def numero_documento
        @numero_documento.to_s.rjust(15, '0') if @numero_documento.present?
      end

      # Formata a carteira dependendo se ela é registrada ou não.
      #
      # Para cobrança COM registro usar: <b>RG</b>
      # Para Cobrança SEM registro usar: <b>SR</b>
      #
      # @return [String]
      #
      def carteira_formatada
        if @carteira.to_s.in?(carteiras_com_registro)
          "RG"
        else
          'SR'
        end
      end

      # Retorna as carteiras com registro da Caixa Econômica Federal.
      # <b>Você pode sobrescrever esse método na subclasse caso exista mais
      # carteiras com registro na Caixa Econômica Federal.</b>
      #
      # @return [Array]
      #
      def carteiras_com_registro
        %w(14)
      end

      def tipo_cobranca
        carteira.first if carteira.present?
      end

      def identificador_de_emissao
        carteira.last if carteira.present?
      end

      # @return [String] Código do Banco descrito na documentação.
      #
      def codigo_banco
        '104'
      end

      # @return [String] Dígito do código do banco descrito na documentação.
      #
      def digito_codigo_banco
        '0'
      end

      # Campo Agência / Código do Cedente (Número fornecido pelo Banco)
      #
      # @return [String]
      #
      def agencia_codigo_cedente
        "#{agencia} / #{codigo_cedente}-#{codigo_cedente_dv}"
      end

      def codigo_cedente_dv
        Modulo11FatorDe2a9RestoZero.new(codigo_cedente)
      end

      # Mostra o campo nosso número calculando o dígito verificador do nosso número.
      #
      # @return [String]
      #
      def nosso_numero
        "#{carteira}#{numero_documento}-#{nosso_numero_dv}"
      end

      def nosso_numero_dv
        Modulo11FatorDe2a9RestoZero.new("#{carteira}#{numero_documento}")
      end

      def nosso_numero_de3a5
        nosso_numero[2..4] if nosso_numero.present?
      end

      def nosso_numero_de6a8
        nosso_numero[5..7] if nosso_numero.present?
      end

      def nosso_numero_de9a17
        nosso_numero[8..16] if nosso_numero.present?
      end


      #  === Código de barras do banco
      #
      #     ________________________________________________________________________________________
      #    | Posição  | Tamanho | Descrição                                                        |
      #    |----------|---------|------------------------------------------------------------------|
      #    | 20 - 25  |   06    | Código do Beneficiário                                           |
      #    | 26 - 26  |   01    | DV do Código do Beneficiário                                     |
      #    | 27 – 29  |   03    | Nosso Número - 3ª a 5ª posição do Nosso Número                   |
      #    | 30 – 30  |   01    | Constante 1, tipo de cobrança (1-Registrada / 2-Sem Registro)    |
      #    | 31 – 33  |   03    | Nosso Número - 6ª a 8ª posição do Nosso Número                   |
      #    | 34 – 34  |   01    | Constante 2, identificador de emissão do boleto (4-Beneficiário) |
      #    | 35 – 43  |   09    | Nosso Número - 9ª a 17ª posição do Nosso Número                  |
      #    | 44 – 44  |   01    | DV do Campo Livre                                                |
      #    -----------------------------------------------------------------------------------------
      #
      # @return [String]
      #
      def codigo_de_barras_do_banco
        codigo = "#{codigo_cedente}#{codigo_cedente_dv}#{nosso_numero_de3a5}#{tipo_cobranca}#{nosso_numero_de6a8}"
        codigo << "#{identificador_de_emissao}#{nosso_numero_de9a17}"

        codigo_dv = Modulo11FatorDe2a9RestoZero.new(codigo)

        "#{codigo}#{codigo_dv}"
      end
    end
  end
end
