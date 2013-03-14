# encoding: utf-8
module BoletoBancario
  module Core
    # Implementação de emissão de boleto bancário pelo Santander.
    #
    # === Documentação Implementada
    #
    # A documentação na qual essa implementação foi baseada está localizada na pasta
    # 'documentacoes_dos_boletos/santander' dentro dessa biblioteca.
    #
    # === Contrato das classes de emissão de boletos
    #
    # Para ver o "<b>contrato</b>" da Emissão de Boletos (geração de código de barras, linha digitável, etc) veja
    # a classe BoletoBancario::Core::Boleto.
    #
    # === Carteiras suportadas
    #
    # Segue abaixo as carteiras suportadas do Santander <b>seguindo a documentação</b>:
    #
    #      _________________________________________________________________________
    #     | Carteira | Descrição                     | Testada/Homologada no banco |
    #     |   101    | Cobrança Simples com registro | Esperando Contribuição      |
    #     |   102    | Cobrança Simples sem registro | Esperando Contribuição      |
    #     |   121    | Penhor Rápida com registro    | Esperando Contribuição      |
    #     --------------------------------------------------------------------------
    #
    # <b>OBS.: Seja um contribuidor dessa gem. Contribua para homologar os boletos e as
    # devidas carteiras junto ao banco Santander.</b>
    #
    # === Validações
    #
    # Caso você queira <b>desabilitar todas as validações</b>, existem alguns métodos que você pode sobrescrever
    # na subclasse que você irá criar. No exemplo abaixo, desabilitará todas as validações:
    #
    #    class Santander < BoletoBancario::Santander
    #      def deve_validar_agencia?
    #        false
    #      end
    #
    #      def deve_validar_codigo_cedente?
    #        false
    #      end
    #
    #      def deve_validar_numero_documento?
    #        false
    #      end
    #
    #      def deve_validar_carteira?
    #        false
    #      end
    #    end
    #
    # <b>OBS.:</b> Muito cuidado ao desabilitar as validações, pois poderá ocorrer problemas no código de barras e na
    # linha digitável. Ambos os métodos podem ser sobrescritos se você quiser também.
    #
    class Santander < Boleto
      include ActionView::Helpers::NumberHelper
      # Campo IOF que será mostrado no código de barras.
      # Padrão é 0 (zero), conforme a documentação do Santander.
      # Para mais detalhes veja o método #iof.
      #
      attr_accessor :iof

      # Tamanho máximo de uma agência no Banco Bradesco.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 4
      #
      def self.tamanho_maximo_agencia
        4
      end

      # Tamanho máximo do número do documento emitido no Boleto.
      # O tamanho máximo é justamente 8 porque no código de barras só é permitido 8 posições para este campo.
      #
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 11
      #
      def self.tamanho_maximo_numero_documento
        12
      end

      # Tamanho máximo do código do cedente emitido no Boleto.
      # O tamanho máximo é justamente 7 porque no código de barras só é permitido 7 posições para este campo.
      #
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 7
      #
      def self.tamanho_maximo_codigo_cedente
        7
      end

      # <b>Carteiras suportadas.</b>
      #
      # <b>Método criado para validar se a carteira informada é suportada.</b>
      #
      # @return [Array]
      #
      def self.carteiras_suportadas
        %w[101 102 121]
      end

      # Validações para os campos abaixo:
      #
      # * Número do documento
      # * Conta Corrente
      # * Agencia
      # * Carteira
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
      #         8
      #       end
      #
      #       def self.tamanho_maximo_numero_documento
      #         9
      #       end
      #
      #       def self.carteiras_suportadas
      #         %w[101 102 121]
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

      # @return [String] 7 caracteres
      #
      def codigo_cedente
        @codigo_cedente.to_s.rjust(7, '0') if @codigo_cedente.present?
      end

      # @return [String] 12 caracteres
      #
      def numero_documento
        @numero_documento.to_s.rjust(12, '0') if @numero_documento.present?
      end

      # Formata a carteira dependendo se ela é registrada ou não.
      #
      # Para cobrança COM registro usar: <b>COBRANCA SIMPLES ECR</b>
      #
      # Para Cobrança SEM registro usar: <b>COBRANCA SIMPLES CSR</b>
      #
      # @return [String]
      #
      def carteira_formatada
        if @carteira.to_s.in?(carteiras_com_registro)
          "COBRANÇA SIMPLES ECR"
        else
          'COBRANÇA SIMPLES CSR'
        end
      end

      # Retorna as carteiras com registro do banco Santander.
      # <b>Você pode sobrescrever esse método na subclasse caso exista mais
      # carteiras com registro no Santander.</b>
      #
      # @return [Array]
      #
      def carteiras_com_registro
        %w(101 121)
      end

      # @return [String] Código do Banco descrito na documentação.
      #
      def codigo_banco
        '033'
      end

      # Dígito do código do banco. Precisa mostrar esse dígito no boleto.
      #
      # @return [String] Dígito do código do banco descrito na documentação.
      #
      def digito_codigo_banco
        '7'
      end

      # Campo Agência / Código do Cedente (Número fornecido pelo Banco)
      #
      # @return [String]
      #
      def agencia_codigo_cedente
        "#{agencia} / #{codigo_cedente}"
      end

      # Mostra o campo nosso número calculando o dígito verificador do nosso número.
      #
      # @return [String]
      #
      def nosso_numero
        "#{numero_documento}-#{digito_nosso_numero}"
      end

      # Calcula o dígito do nosso número pelo Módulo 11 fator de 2 a 9 verificando o resto como zero.
      # Para mais detalhes veja a classe <b>BoletoBancario::Calculos::Modulo11FatorDe2a9RestoZero</b>.
      #
      # @return [String]
      #
      def digito_nosso_numero
        Modulo11FatorDe2a9RestoZero.new(numero_documento)
      end

      #  === Código de barras do banco
      #
      #     ___________________________________________________________________________________________________
      #    | Posição  | Tamanho | Descrição                                                                   |
      #    |----------|---------|-----------------------------------------------------------------------------|
      #    | 20       |  01     | Fixo '9'                                                                    |
      #    | 21-27    |  07     | Código do cedente padrão Santander                                          |
      #    | 28-40    |  13     | Nosso Número (veja a observação abaixo)                                     |
      #    | 41       |  01     | IOF (veja o método #iof)                                                    |
      #    | 42-44    |  03     | Carteira                                                                    |
      #    ----------------------------------------------------------------------------------------------------
      #
      # <b>OBS.:</b> Caso o arquivo de registro para os títulos seja de 400 bytes (CNAB).
      # Utilizar somente 08 posições do Nosso Numero (07 posições + DV), zerando os 05 primeiros dígitos.
      # Utilizar somente 09 posições do Nosso Numero (08 posições + DV), zerando os 04 primeiros dígitos.
      #
      # Para utilizar esse número de posições no nosso número é só colocar o tamanho ideal no
      # numero_documento.
      # Por exemplo:
      #
      #    Santander.new(:numero_documento => '1234567')  # Irá zerar os 05 primeiros dígitos.
      #    Santander.new(:numero_documento => '12345678') # Irá zerar os 04 primeiros dígitos.
      #
      # @return [String]
      #
      def codigo_de_barras_do_banco
        "9#{codigo_cedente}#{numero_documento}#{digito_nosso_numero}#{iof}#{carteira}"
      end

      # IOF é a sigla de Imposto sobre Operações de Crédito, Câmbio e Seguros,
      # e é um imposto federal no Brasil.
      #
      # Seguradoras (Se 7% informar 7. Limitado a 9%)
      # <b>Demais clientes usar 0 (zero)</b>
      #
      # @return [String]
      #
      def iof
        return @iof.to_s if @iof.present?

        '0'
      end

      def to_html
        HTMLRenderer.render(self)
      end
    end
  end
end