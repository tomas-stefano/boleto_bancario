# encoding: utf-8
module BoletoBancario
  module Core
    # Implementação de emissão de boleto bancário pelo Itaú.
    #
    # === Documentação Implementada
    #
    # A documentação na qual essa implementação foi baseada está localizada na pasta
    # 'documentacoes_dos_boletos/itau' dentro dessa biblioteca.
    #
    # === Contrato das classes de emissão de boletos
    #
    # Para ver o "<b>contrato</b>" da Emissão de Boletos (geração de código de barras, linha digitável, etc) veja
    # a classe BoletoBancario::Core::Boleto.
    #
    # === Carteiras suportadas
    #
    # Segue abaixo as carteiras suportadas do itáu <b>seguindo a documentação</b>:
    #
    #      _______________________________________________________________________________________________________
    #     | Carteira          | Descrição                                          | Testada/Homologada no banco |
    #     |   107             | Sem registro com emissão integral – 15 posições    | Esperando Contribuição      |
    #     |   109             | Direta eletrônica sem emissão – simples            | Esperando Contribuição      |
    #     |   174             | Sem registro emissão parcial com protesto borderô  | Esperando Contribuição      |
    #     |   175             | Sem registro sem emissão com protesto eletrônico   | Esperando Contribuição      |
    #     |   196             | Sem registro com emissão e entrega – 15 posições   | Esperando Contribuição      |
    #     |   198             | Sem registro sem emissão 15 dígitos                | Esperando Contribuição      |
    #     |   126, 131, 146   | -------------------------------------------------- | Esperando Contribuição      |
    #     |   122, 142, 143   | -------------------------------------------------- | Esperando Contribuição      |
    #     |   150, 168        | -------------------------------------------------- | Esperando Contribuição      |
    #     --------------------------------------------------------------------------------------------------------
    #
    # <b>OBS.: Seja um contribuidor dessa gem. Contribua para homologar os boletos e as
    # devidas carteiras junto ao banco Itaú.</b>
    #
    # === Exemplos
    #
    # O recomendado é criar uma subclasse de BoletoBancario::Itau
    #
    #     class BoletoItau < BoletoBancario::Itau
    #     end
    #
    # === Criando um boleto
    #
    #    boleto_itau = BoletoItau.new do |boleto|
    #      boleto.conta_corrente   = '89755'
    #      boleto.agencia          = '0097'
    #      boleto.carteira         = '198'
    #      boleto.numero_documento = '12345678'
    #      boleto.codigo_cedente   = '909014'
    #    end
    #
    # === Validações
    #
    # A classe Itaú possui suas próprias validações.
    # Primeiramente, <b>antes de renderizar qualquer boleto você precisar verificar se esse o boleto é válido</b>:
    #
    #     if boleto_itau.valid?
    #        # render boleto_itau
    #     else
    #        # ...
    #     end
    #
    # === Campos do Boleto
    #
    #    boleto_itau.codigo_de_barras
    #
    #    boleto_itau.linha_digitavel
    #
    #    boleto_itau.nosso_numero
    #
    #    boleto_itau.agencia_codigo_cedente
    #
    #    boleto_itau.carteira_formatada # Formata a carteira, para mostrar no boleto.
    #
    #    boleto_itau.numero_documento
    #
    #    boleto_itau.valor_documento
    #
    # === Sobrescrevendo validações
    #
    # Se você quiser sobrescrever alguma validação dessa classe a gem de boleto bancário
    # possui alguns modos de fazer isso.
    #
    # Caso você precise mudar as validações, você pode sobrescrever alguns métodos que possuem <b>"Magic numbers"</b>.
    # Foi colocado dessa forma, já que os bancos mudam bastante esse tipo de validação.
    # Por exemplo, atualmente a conta corrente é validado com <b>'5' como máximo de tamanho</b>.
    # Caso você queira que valide como 6, mude conforme abaixo:
    #
    #    class BoletoItau < BoletoBancario::Itau
    #      def self.tamanho_maximo_conta_corrente
    #        6
    #      end
    #    end
    #
    # Ou você pode desativar as validações que são feitas, sobrescrevendo os métodos de validação:
    #
    #    class BoletoItau < BoletoBancario::Itau
    #      def deve_validar_agencia?
    #       false
    #     end
    #
    #     def deve_validar_conta_corrente?
    #       false
    #     end
    #
    #     def deve_validar_codigo_cedente?
    #       false
    #     end
    #
    #     def deve_validar_numero_documento?
    #       false
    #     end
    #
    #     def deve_validar_carteira?
    #       false
    #     end
    #   end
    #
    # <b>Obs.: Mudar as regras de validação podem influenciar na emissão do boleto em si.
    # Talvez você precise analisar o efeito no #codigo_de_barras e na #linha_digitável (ambos podem ser
    # sobreescritos também).</b>
    #
    # Caso exista algum cenário de sobrescrita de validação contate o dono dessa gem pelo github e conte um
    # pouco mais sobre esses cenários.
    #
    class Itau < Boleto
      # Usado somente em carteiras especiais para complementar o número do documento.
      #
      attr_accessor :seu_numero

      # Tamanho máximo de uma conta corrente no Banco Itaú.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 5
      #
      def self.tamanho_maximo_conta_corrente
        5
      end

      # Tamanho máximo de uma agência no Banco Itaú.
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
      # @return [Fixnum] 8
      #
      def self.tamanho_maximo_numero_documento
        8
      end

      # Tamanho máximo do código do cedente emitido no Boleto.
      # O tamanho máximo é justamente 5 porque no código de barras só é permitido 5 posições para este campo.
      #
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 5
      #
      def self.tamanho_maximo_codigo_cedente
        5
      end

      # Tamanho máximo do seu número emitido no Boleto.
      # O tamanho máximo é justamente 7 porque no código de barras só é permitido 7 posições para este campo.
      #
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 7
      #
      def self.tamanho_maximo_seu_numero
        7
      end

      # Tamanho máximo da carteira.
      # O tamanho máximo é justamente 3 porque no código de barras só é permitido 3 posições para este campo.
      #
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 3
      #
      def self.tamanho_maximo_carteira
        3
      end

      # Campos obrigatórios
      #
      # * Agencia
      # * Conta Corrente
      # * Dígito da conta corrente
      #
      validates :agencia, :conta_corrente, :digito_conta_corrente, presence: true
      validates :digito_conta_corrente, length: { maximum: 1 }

      # Validações de tamanho para os campos abaixo:
      #
      # * Número do documento
      # * Conta Corrente
      # * Agencia
      # * Carteira
      #
      # Se você quiser sobrescrever os tamanhos permitidos, ficará a sua responsabilidade.
      # Basta você sobrescrever os métodos de validação:
      #
      #    class BoletoItau < BoletoBancario::Core::Itau
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
      #    end
      #
      # Obs.: Mudar as regras de validação podem influenciar na emissão do boleto em si.
      # Talvez você precise analisar o efeito no #codigo_de_barras e na #linha_digitável (ambos podem ser
      # sobreescritos também).
      #
      validates :numero_documento, length: { maximum: tamanho_maximo_numero_documento }, if: :deve_validar_numero_documento?
      validates :conta_corrente,   length: { maximum: tamanho_maximo_conta_corrente   }, if: :deve_validar_conta_corrente?
      validates :agencia,          length: { maximum: tamanho_maximo_agencia          }, if: :deve_validar_agencia?
      validates :carteira,         length: { maximum: tamanho_maximo_carteira         }, if: :deve_validar_carteira?

      # Campos obrigatórios e validações de tamanho para os campos:
      #
      # * Código do cedente
      # * Seu número
      #
      # <b>Obs.: Essas validações só ocorrerão se a carteira do boleto for especial.</b>
      # Para mais detalhes veja o método carteiras especiais dessa classe.
      #
      validates :codigo_cedente, :seu_numero, presence: true, :if => :carteira_especial?
      validates :codigo_cedente, length: { maximum: tamanho_maximo_codigo_cedente }, :if => :deve_validar_codigo_cedente_carteira_especial?
      validates :seu_numero,     length: { maximum: tamanho_maximo_seu_numero     }, :if => :deve_validar_seu_numero_carteira_especial?

      # <b>Nosso número</b> é a identificação do título no banco.
      # Eu diria que há uma diferença bem sutil entre esse campo e o seu número.
      #
      # @return [String] 8 caracteres.
      #
      def numero_documento
        @numero_documento.to_s.rjust(8, '0') if @numero_documento.present?
      end

      # <b>Seu número</b> é a identificação do documento na empresa emitida.
      # <b>OBS.:</b> Campo usado somente para as <b>carteiras_especiais</b>.
      #
      # @return [String] 7 caracteres.
      #
      def seu_numero
        @seu_numero.to_s.rjust(7, '0') if @seu_numero.present?
      end

      # @return [String] 4 caracteres
      #
      def agencia
        @agencia.to_s.rjust(4, '0') if @agencia.present?
      end

      # @return [String] 5 caracteres.
      #
      def conta_corrente
        @conta_corrente.to_s.rjust(5, '0') if @conta_corrente.present?
      end

      # <b>Código do Cedente</b> é o código do cliente, fornecido pelo banco.
      # <b>OBS.:</b> Campo usado somente para as <b>carteiras_especiais</b>.
      #
      # @return [String] 5 caracteres.
      #
      def codigo_cedente
        @codigo_cedente.to_s.rjust(5, '0') if @codigo_cedente.present?
      end

      # @return [String] Código do Banco descrito na documentação (Pag. 49).
      #
      def codigo_banco
        '341'
      end

      # Dígito do código do banco. Precisa mostrar esse dígito no boleto.
      #
      # @return [String] Dígito do código do banco descrito na documentação (Pag. 49).
      #
      def digito_codigo_banco
        '7'
      end

      # Agência, conta corrente and dígito da conta corrente formatado.
      #
      # @return [String] Campo descrito na documentação (Pag. 50).
      #
      def agencia_codigo_cedente
        "#{agencia} / #{conta_corrente}-#{digito_conta_corrente}"
      end

      # Nosso Número descrito na documentação (Pag. 53).
      #
      # @return [String] Carteira, número do documento e calculo do dígito do nosso número.
      #
      def nosso_numero
        "#{carteira}/#{numero_documento}-#{digito_nosso_numero}"
      end

      # Para a grande maioria das carteiras, são considerados para a obtenção do dígito do nosso número,
      # os dados “AGÊNCIA / CONTA (sem dígito) / CARTEIRA / NOSSO NÚMERO”,
      # calculado pelo critério do Módulo 10 (veja a classe Modulo10 para mais detalhes).
      #
      # À exceção, estão as carteiras 126 - 131 - 146 - 150 e 168 cuja obtenção
      # está baseada apenas nos dados “CARTEIRA/NOSSO NÚMERO” da operação.
      #
      # @return [String]
      #
      def digito_nosso_numero
        if carteira.in?(carteiras_com_calculo_junto_com_numero_documento)
          Modulo10.new("#{carteira}#{numero_documento}")
        else
          Modulo10.new("#{agencia}#{conta_corrente}#{carteira}#{numero_documento}")
        end
      end

      # Carteiras que devem ser calculadas o módulo 10 usando carteira e número do documento.
      # Você pode sobrescrever esse método na subclasse caso for necessário
      # <b>para incluir mais carteiras nesse cenário</b>.
      #
      # @return [Array] Carteiras.
      #
      def carteiras_com_calculo_junto_com_numero_documento
        %w(126 131 146 150 168)
      end

      # Formata a <b>segunda posição do código de barras</b>.
      #
      # A carteira de cobrança 198 é uma carteira especial, sem registro, na qual são utilizadas 15 posições
      # numéricas para identificação do título liquidado (8 do Nosso Número e 7 do Seu Número).
      # Nessa mesma situação estão as carteiras 107, 122, 142, 143 e 196.
      #
      # === Carteiras 107, 122, 142, 143, 196 e 198
      #
      # Para essas carteiras o formato do código de barras é o seguinte:
      #
      #     ________________________________________________________________
      #    | Posição  | Tamanho | Descrição                                |
      #    |----------|---------|------------------------------------------|
      #    | 20-22    |  03     | Carteira                                 |
      #    | 23-30    |  08     | Nosso Número (Número do documento)       |
      #    | 31-37    |  07     | Seu número                               |
      #    | 38-42    |  05     | Código do Cliente (fornecido pelo banco) |
      #    | 43       |  01     | DAC dos campos acima (posições 20 a 42)  |
      #    | 44       |  01     | Zero                                     |
      #    -----------------------------------------------------------------
      #
      # === Demais Carteiras
      #
      # Para as demais carteiras o formato do código de barras é o seguinte:
      #
      #     _________________________________________________________________________________________
      #    | Posição  | Tamanho | Descrição                                                         |
      #    |----------|---------|-------------------------------------------------------------------|
      #    | 20-22    |  03     | Carteira                                                          |
      #    | 23-30    |  08     | Nosso Número (Número do documento)                                |
      #    | 31       |  01     | DAC Modulo 10 (Agencia/Conta Corrente/Carteira/Nosso Número)      |
      #    | 32-35    |  04     | Agência                                                           |
      #    | 36-40    |  05     | Número da conta corrente                                          |
      #    | 41       |  01     | DAC Modulo 10 [Agência/Conta Corrente] (Digito da Conta Corrente) |
      #    | 42-44    |  03     | Zeros                                                             |
      #    ------------------------------------------------------------------------------------------
      #
      # Algumas observações sobre as demais carteiras:
      #
      # * O campo DAC na posição 31 se refere ao método #digito_nosso_numero pois calcula o
      # dígito verificador baseado na carteira.
      #
      # * O campo DAC na posição 41 se refere ao método #digito_conta_corrente pois calcula o
      # dígito verificador baseado na agencia + conta corrente.
      #
      # * A posição 41 se refere ao dígito verificador da conta corrente.
      #
      def codigo_de_barras_do_banco
        if carteira.in?(carteiras_especiais)
          codigo = "#{carteira}#{numero_documento}#{seu_numero}#{codigo_cedente}"
          "#{codigo}#{Modulo10.new(codigo)}0"
        else
          "#{carteira}#{numero_documento}#{digito_nosso_numero}#{agencia}#{conta_corrente}#{digito_conta_corrente}000"
        end
      end

      # As carteiras de cobrança <b>107, 122, 142, 143, 196 e 198 são carteiras especiais</b>,
      # na qual são utilizadas 15 posições numéricas para identificação do título
      # liquidado (8 do Nosso Número e 7 do Seu Número).
      #
      # <b>Você pode sobrescrever esse método na subclasse caso haja mais carteiras nessa posição descrita acima</b>.
      #
      # @return [Array] Carteiras especiais que calculam o código barras usando 'Seu número' e 'Código do Cedente'.
      #
      def carteiras_especiais
        %w(107 122 142 143 196 198)
      end

      # Verifica se a carteira é especial.
      # Para mais detalhes veja o método #carteiras_especiais.
      #
      # @return [True, False]
      #
      def carteira_especial?
        carteira.to_s.in?(carteiras_especiais)
      end

      # Verifica se deve validar o código do cedente e se a carteira é especial.
      #
      # Métodos usado para verificar se deve realizar a validação do campo 'codigo_cedente'.
      # <b>Sobrescreva esse método na subclasse, caso você mesmo queira fazer as validações</b>.
      #
      # @return [True]
      #
      def deve_validar_codigo_cedente_carteira_especial?
        deve_validar_codigo_cedente? and carteira_especial?
      end

      # Verifica se deve validar o seu número e se a carteira é especial.
      #
      # Métodos usado para verificar se deve realizar a validação do campo 'codigo_cedente'.
      # <b>Sobrescreva esse método na subclasse, caso você mesmo queira fazer as validações</b>.
      #
      # @return [True]
      #
      def deve_validar_seu_numero_carteira_especial?
        deve_validar_seu_numero? and carteira_especial?
      end

      # Verifica se deve validar o seu número. O padrão é validar o seu número.
      #
      # Métodos usado para verificar se deve realizar a validação do campo 'seu_numero'.
      # <b>Sobrescreva esse método na subclasse, caso você mesmo queira fazer as validações</b>.
      #
      # @return [True] true
      #
      def deve_validar_seu_numero?
        true
      end
    end
  end
end