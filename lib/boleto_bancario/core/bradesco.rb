# encoding: utf-8
module BoletoBancario
  module Core
    # Implementação de emissão de boleto bancário pelo Bradesco.
    #
    # === Documentação Implementada
    #
    # A documentação na qual essa implementação foi baseada está localizada na pasta
    # 'documentacoes_dos_boletos/bradesco' dentro dessa biblioteca.
    #
    # === Contrato das classes de emissão de boletos
    #
    # Para ver o "<b>contrato</b>" da Emissão de Boletos (geração de código de barras, linha digitável, etc) veja
    # a classe BoletoBancario::Core::Boleto.
    #
    # === Carteiras suportadas
    #
    # Segue abaixo as carteiras suportadas do bradesco <b>seguindo a documentação</b>:
    #
    #      _________________________________________________________________________
    #     | Carteira | Descrição                     | Testada/Homologada no banco |
    #     |   03     | Sem registro                  | Esperando Contribuição      |
    #     |   06     | Sem registro                  | Esperando Contribuição      |
    #     |   09     | Com registro                  | Esperando Contribuição      |
    #     |   19     | Com registro                  | Esperando Contribuição      |
    #     |   21     | Cobrança Interna com registro | Esperando Contribuição      |
    #     |   22     | Cobrança Interna sem registro | Esperando Contribuição      |
    #     --------------------------------------------------------------------------
    #
    # <b>OBS.: Seja um contribuidor dessa gem. Contribua para homologar os boletos e as
    # devidas carteiras junto ao banco Bradesco.</b>
    #
    # === Exemplos
    #
    # O recomendado é criar uma subclasse de BoletoBancario::Bradesco
    #
    #     class Bradesco < BoletoBancario::Bradesco
    #     end
    #
    # E a partir daí usar a sua classe para emitir o boleto:
    #
    #    Bradesco.new do |boleto|
    #      boleto.conta_corrente   = '89755'
    #      boleto.agencia          = '0097'
    #      boleto.carteira         = '198'
    #      boleto.numero_documento = '12345678'
    #      boleto.codigo_cedente   = '909014'
    #    end
    #
    # === Validações
    #
    # A classe Bradesco possui suas próprias validações.
    # Primeiramente, <b>antes de renderizar qualquer boleto você precisar verificar se esse boleto é válido</b>:
    #
    #     @bradesco = Bradesco.new
    #     if @bradesco.valid?
    #        # render @bradesco
    #     else
    #        # ...
    #     end
    #
    # Se você quiser sobrescrever alguma validação dessa classe a gem de boleto bancário
    # possui alguns modos de fazer isso.
    #
    # === Sobrescrevendo validações
    #
    # Caso você precise mudar as validações, você pode sobrescrever alguns métodos que possuem <b>"Magic numbers"</b>.
    # Foi colocado dessa forma, já que os bancos mudam bastante esse tipo de validação.
    # Por exemplo, atualmente a conta corrente é validado com <b>'5' como máximo de tamanho</b>.
    # Caso você queira que valide como 6, mude conforme abaixo:
    #
    #    class Bradesco < BoletoBancario::Bradesco
    #      def self.tamanho_maximo_conta_corrente
    #        6
    #      end
    #    end
    #
    # <b>Obs.: Mudar as regras de validação podem influenciar na emissão do boleto em si.
    # Você precisará analisar o efeito no #codigo_de_barras, #nosso_numero e na
    # #linha_digitável (ambos podem ser sobreescritos também).</b>
    #
    # Caso exista algum cenário de sobrescrita de validação contate o dono dessa gem pelo github e conte um
    # pouco mais sobre esses cenários.
    #
    class Bradesco < Boleto
      # Tamanho máximo de uma conta corrente no Banco Bradesco.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 7
      #
      def self.tamanho_maximo_conta_corrente
        7
      end

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
        11
      end

      # Tamanho máximo da carteira.
      # O tamanho máximo é justamente 2 porque no código de barras só é permitido 2 posições para este campo.
      #
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 2
      #
      def self.tamanho_maximo_carteira
        2
      end

      validates :agencia, :digito_agencia, :conta_corrente, :digito_conta_corrente, presence: true

      # Validações de tamanho para os campos abaixo:
      #
      # * Agencia
      # * Digito verificador da agencia
      # * Conta corrente
      # * Digito verificador da conta corrente
      # * Número do documento
      # * Carteira
      #
      # Se você quiser sobrescrever os tamanhos permitidos, ficará a sua responsabilidade.
      # Basta você sobrescrever os métodos de validação:
      #
      #    class Bradesco < BoletoBancario::Core::Bradesco
      #       def self.tamanho_maximo_agencia
      #         5
      #       end
      #
      #       def self.tamanho_maximo_conta_corrente
      #         6
      #       end
      #
      #       def self.tamanho_maximo_numero_documento
      #         9
      #       end
      #
      #       def self.tamanho_maximo_carteira
      #         2
      #       end
      #    end
      #
      # Obs.: Mudar as regras de validação podem influenciar na emissão do boleto em si.
      # Você precisará analisar o efeito no #codigo_de_barras, #nosso_numero e na
      # #linha_digitável (ambos podem ser sobreescritos também).
      #
      validates :digito_agencia,        length: { maximum: 1  }
      validates :digito_conta_corrente, length: { maximum: 1  }
      validates :agencia,          length: { maximum: tamanho_maximo_agencia          }, if: :deve_validar_agencia?
      validates :conta_corrente,   length: { maximum: tamanho_maximo_conta_corrente   }, if: :deve_validar_conta_corrente?
      validates :numero_documento, length: { maximum: tamanho_maximo_numero_documento }, if: :deve_validar_numero_documento?
      validates :carteira,         length: { maximum: tamanho_maximo_carteira         }, if: :deve_validar_carteira?

      # @return [String] 7 caracteres
      #
      def conta_corrente
        @conta_corrente.to_s.rjust(7, '0') if @conta_corrente.present?
      end

      # @return [String] 4 caracteres
      #
      def agencia
        @agencia.to_s.rjust(4, '0') if @agencia.present?
      end

      # @return [String] 11 caracteres
      #
      def numero_documento
        @numero_documento.to_s.rjust(11, '0') if @numero_documento.present?
      end

      # @return [String] 2 caracteres
      #
      def carteira
        @carteira.to_s.rjust(2, '0') if @carteira.present?
      end

      # Número da Carteira de Cobrança, que a empresa opera no Banco.
      # No caso da Cobrança Interna será:
      #
      # 21 – Cobrança Interna Com Registro
      # 22 – Cobrança Interna sem registro
      #
      # Para as demais carteiras, retornar o número da carteira.
      #
      def carteira_formatada
        if cobranca_interna_formatada.present?
          cobranca_interna_formatada
        else
          carteira
        end
      end

      # @return [String] Código do Banco descrito na documentação.
      #
      def codigo_banco
        '237'
      end

      # Dígito do código do banco. Precisa mostrar esse dígito no boleto.
      #
      # @return [String] Dígito do código do banco descrito na documentação.
      #
      def digito_codigo_banco
        '2'
      end

      # Campo preenchido com:
      #
      # - Agência com 4 caracteres - digito da agência / Conta de Cobrança com 7 caracteres - Digito da Conta
      #
      # Exemplo: 9999-D/9999999-D
      #
      # Obs.: Preencher com zeros a Esquerda quando necessário.
      #
      # @return [String] Agência e Código do Cedente que será exibido no boleto
      #
      def agencia_codigo_cedente
        "#{agencia}-#{digito_agencia} / #{conta_corrente}-#{digito_conta_corrente}"
      end

      # Nosso Número descrito na documentação (Pag. 53).
      #
      # Carteira com 2 (dois) caracteres / N.Número com 11 (onze) caracteres + digito.
      #
      # Exemplo: 99 / 99999999999-D
      #
      def nosso_numero
        "#{carteira}/#{numero_documento}-#{digito_nosso_numero}"
      end

      # Para o cálculo do dígito, será necessário acrescentar o número da carteira à esquerda
      # antes do Nosso Número (número do documento), e aplicar o módulo 11, com fatores de 2 a 7.
      #
      # Para mais detalhes de como o cálculo é feito veja a classe Modulo11FatorDe2a7.
      #
      # @return [String] Retorno do cálculo do módulo 11 na base 7 (2,3,4,5,6,7)
      #
      def digito_nosso_numero
        Modulo11FatorDe2a7.new("#{carteira}#{numero_documento}")
      end

      #  === Código de barras do banco
      #
      #     ___________________________________________________________________________________________________
      #    | Posição  | Tamanho | Descrição                                                                   |
      #    |----------|---------|-----------------------------------------------------------------------------|
      #    | 20-23    |  04     | Agência (Sem o digito, completar com zeros a esquerda se necessário)        |
      #    | 24-25    |  02     | Carteira                                                                    |
      #    | 26-36    |  11     | Número do Documento - Número do Nosso Número (Sem o digito verificador)     |
      #    | 37-43    |  07     | Conta Corrente (Sem o digito, completar com zeros a esquerda se necessário) |
      #    | 44       |  01     | Zero                                                                        |
      #    ----------------------------------------------------------------------------------------------------
      #
      def codigo_de_barras_do_banco
        "#{agencia}#{carteira}#{numero_documento}#{conta_corrente}0"
      end

      # @api private
      # Retorna a mensagem que devera aparecer no campo carteira para cobranca interna.
      #
      # @return [String]
      #
      def cobranca_interna_formatada
        cobranca_interna = { '21' => '21 – Cobrança Interna Com Registro', '22' => '22 – Cobrança Interna sem registro' }
        cobranca_interna[carteira.to_s]
      end
    end
  end
end