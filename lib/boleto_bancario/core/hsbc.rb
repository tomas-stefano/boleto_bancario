# encoding: utf-8
module BoletoBancario
  module Core
    # Implementação de emissão de boleto bancário pelo Banco HSBC.
    #
    # === Documentação Implementada
    #
    # A documentação na qual essa implementação foi baseada está localizada na pasta
    # 'documentacoes_dos_boletos/hsbc' dentro dessa biblioteca.
    #
    # === Carteiras
    #      ______________________________________________
    #     | Carteira | Descrição               | Formato |
    #     |    2     | Cobrança não Registrada | CNR     |
    #     |______________________________________________|
    #
    class Hsbc < Boleto
      # Tamanho máximo do código do cedente emitido no Boleto.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 7
      #
      def self.tamanho_maximo_codigo_cedente
        7
      end

      # Tamanho máximo do número do documento emitido no Boleto.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 13
      #
      def self.tamanho_maximo_numero_documento
        13
      end

      # Validações para os campos abaixo:
      #
      # * Conta Corrente
      # * Número do documento
      #
      # Se você quiser sobrescrever os metodos, <b>ficará a sua responsabilidade.</b>
      # Basta você sobrescrever os métodos de validação:
      #
      #    class Hsbc < BoletoBancario::Core::Hsbc
      #       def self.tamanho_maximo_codigo_cedente
      #         5
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
      validates :codigo_cedente, presence: true

      validates :codigo_cedente,   length: { maximum: tamanho_maximo_codigo_cedente   }, if: :deve_validar_codigo_cedente?
      validates :numero_documento, length: { maximum: tamanho_maximo_numero_documento }, if: :deve_validar_numero_documento?

      # @return [String] 7 caracteres
      #
      def codigo_cedente
        @codigo_cedente.to_s.rjust(7, '0') if @codigo_cedente.present?
      end

      # @return [String] 13 caracteres
      #
      def numero_documento
        @numero_documento.to_s.rjust(13, '0') if @numero_documento.present?
      end

      # Para Cobrança NÃO registrada usar: <b>CNR</b>
      #
      # @return [String]
      #
      def carteira_formatada
        'CNR'
      end

      def carteira
        '2'
      end

      # @return [String] Código do Banco descrito na documentação.
      #
      def codigo_banco
        '399'
      end

      # @return [String] Não possui dígito do código do banco.
      #
      def digito_codigo_banco
        ''
      end

      # Campo Agência / Código do Cedente
      #
      # @return [String]
      #
      def agencia_codigo_cedente
        "#{codigo_cedente}"
      end

      # Nosso numero calculado pelo Tipo Identificador 4 descrito na documentação
      #
      # @return [String]
      #
      def nosso_numero
        "#{numero_documento}#{nosso_numero_dv_1}#{tipo_identificador}#{nosso_numero_dv_2}"
      end

      def nosso_numero_dv_1
        Modulo11FatorDe9a2.new(numero_documento)
      end

      def tipo_identificador
        4
      end

      def nosso_numero_dv_2
        soma = "#{numero_documento}#{nosso_numero_dv_1}#{tipo_identificador}".to_i
        soma += codigo_cedente.to_i
        soma += data_vencimento_para_calculo.to_i

        Modulo11FatorDe9a2.new(soma)
      end

      # Data do vencimento para ser usada no calculo do segundto dígito identificador do nosso numero
      #
      # Exemplo: 18/03/2015 => 180315
      #
      # @return [String]
      #
      def data_vencimento_para_calculo
        @data_vencimento.strftime('%d%m%y') if @data_vencimento.present?
      end

      #  === Código de barras do banco
      #
      #     _______________________________________________________________________________________
      #    | Posição  | Tamanho | Descrição                                                        |
      #    |----------|---------|------------------------------------------------------------------|
      #    | 20 - 26  |   07    | Código do Cedente                                                |
      #    | 27 - 39  |   13    | Código do Documento                                              |
      #    | 40 - 43  |   04    | Data de Vencimento no Formato Juliano.                           |
      #    | 44 – 44  |   01    | Código do Produto CNR, número 2.                                 |
      #    |_______________________________________________________________________________________|
      #
      # @return [String]
      #
      def codigo_de_barras_do_banco
        "#{codigo_cedente}#{numero_documento}#{data_vencimento_formato_juliano}#{carteira}"
      end

      # Data do vencimento no formato Juliano composta por 4 dígitos
      #
      # @return [String]
      #
      def data_vencimento_formato_juliano
        "#{@data_vencimento.yday.to_s.rjust(3, '0')}#{@data_vencimento.year.to_s.last}" if @data_vencimento.present?
      end
    end
  end
end
