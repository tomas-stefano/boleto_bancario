# encoding: utf-8
module BoletoBancario
  module Core
    # @abstract Métodos { #codigo_banco, #digito_codigo_banco, #agencia_codigo_cedente, #nosso_numero, #codigo_de_barras_do_banco}
    # Métodos para serem escritos nas subclasses (exitem outros opcionais, conforme visto nessa documentação).
    #
    class Boleto
      include BoletoBancario::Calculos

      # Seguindo a interface do Active Model para:
      # * Validações;
      # * Internacionalização;
      # * Nomes das classes para serem manipuladas;
      #
      include ActiveModel::Validations
      include ActiveModel::Conversion
      extend  ActiveModel::Naming
      extend  ActiveModel::Translation

      # Nome/Razão social que aparece no campo 'Cedente' no boleto.
      #
      attr_accessor :cedente

      # <b>Código do Cedente é o código do cliente, fornecido pelo banco.</b>
      #
      # Alguns bancos, dependendo do banco e da carteira, precisam desse campo preenchido.
      # Em compensação, outros bancos (a minoria) não fazem utilização desse campo.
      #
      attr_accessor :codigo_cedente

      # Documento do Cedente (CPF ou CNPJ).
      # <b>OBS.: Esse campo não possui validação do campo. Caso você precise imeplemente na subclasse.</b>
      #
      # Esse campo serve apenas para mostrar no boleto no campo "CPF/CNPJ".
      #
      attr_accessor :documento_cedente

      # Deve ser informado o endereço completo do Cedente.
      # Se o título possuir a figura de Sacador Avalista o endereço informado
      # deverá ser do Sacador Avalista, conforme Lei Federal 12.039 de 01/10/2009.
      #
      # <b>Campo Obrigatório</b>
      #
      attr_accessor :endereco_cedente

      # Data do vencimento do boleto. Campo auto explicativo.
      #
      # <b>Campo Obrigatório</b>
      #
      attr_accessor :data_vencimento

      # Número do documento que será mostrado no boleto.
      # Campo de resposabilidade do Cedente e cada banco possui um tamanho esperado.
      #
      attr_accessor :numero_documento

      # Valor total do documento. Campo auto explicativo.
      #
      # <b>Campo Obrigatório</b>.
      #
      attr_accessor :valor_documento

      # Uma carteira de cobrança define o modo como o boleto é tratado pelo banco.
      # Existem duas grandes divisões: carteiras não registradas e carteiras registradas.
      #
      # === Carteiras Não Registradas
      #
      # Significa que não há registro no banco sobre os boletos gerados, ou seja, você não precisa
      # notificar o banco a cada boleto gerado.
      # Neste caso a cobrança de taxa bancária é feita por boleto pago.
      #
      # === Carteiras Registradas
      #
      # Você precisa notificar o banco sobre todos os boletos gerados, em geral enviando um
      # arquivo chamado "arquivo de remessa".
      # Neste caso, normalmente existe uma taxa bancária por boleto gerado, independentemente de ele ser pago.
      # Nestas carteiras também se encaixam serviços bancários adicionais, como protesto em caso de não pagamento.
      #
      # <b>Campo Obrigatório</b>
      #
      attr_accessor :carteira

      # Número da agência. Campo auto explicativo.
      #
      attr_accessor :agencia

      # Dígito da agência. Campo auto explicativo.
      # Alguns bancos tem o agência, enquanto outros não possuem.
      #
      attr_accessor :digito_agencia

      # Número da Conta corrente. Campo auto explicativo.
      #
      attr_accessor :conta_corrente

      # Dígito da conta corrente. Campo auto explicativo.
      # Alguns bancos tem o dígito da conta corrente outros não.
      #
      attr_accessor :digito_conta_corrente

      # Código da moeda. Campo auto explicativo.
      # Padrão '9' (Real).
      #
      attr_accessor :codigo_moeda

      # Essencial para identificação da moeda em que a operação foi efetuada.
      #
      # Padrão 'R$' (Real).
      #
      attr_accessor :especie

      # Normalmente se vê neste campo a informação "DM" que quer dizer duplicata mercantil,
      # mas existem inúmeros tipos de espécie, <b>neste caso é aconselhável discutir com o banco
      # qual a espécie de documento será utilizada</b>, a identificação incorreta da espécie do documento
      # não vai impedir que o boleto seja pago e nem que o credito seja efetuado na conta do cliente,
      # mas <b>pode ocasionar na impossibilidade de se protestar o boleto caso venha a ser necessário.</b>
      #
      # Segue a sigla e descrição do campo especie do documento:
      #
      #     ---------------------------------
      #    | Sigla  | Descrição             |
      #    ----------------------------------
      #    |  NP    | Nota Promissória      |
      #    |  NS    | Nota de Seguro        |
      #    |  CS    | Cobrança Seriada      |
      #    |  REC   | Recibo                |
      #    |  LC    | Letras de Câmbio      |
      #    |  ND    | Notas de débito       |
      #    |  DS    | Duplicata de Serviços |
      #    |  DM    | Duplicata Mercantil   |
      #    ---------------------------------|
      #
      # Padrão 'DM' (Duplicata Mercantil)
      #
      attr_accessor :especie_documento

      # Data em que o documento foi gerado. Campo auto explicativo.
      #
      attr_accessor :data_documento

      # Nome do sacado.
      #
      # O sacado é a pessoa para o qual o boleto está sendo emitido, podemos resumir dizendo
      # que o sacado é o cliente do Cedente, ou aquele para o qual uma determina mercadoria
      # foi vendida e o pagamento desta será efetuado por meio de boleto de cobrança.
      #
      # <b>Campo Obrigatório</b>.
      #
      attr_accessor :sacado

      # Documento do sacado.
      #
      # <b>OBS.: Esse campo não possui validação do campo. Caso você precise imeplemente na subclasse.</b>
      #
      # Esse campo serve apenas para mostrar no boleto no campo "CPF/CNPJ".
      #
      attr_accessor :documento_sacado

      # Validações de todos os boletos
      #
      validates :carteira, :valor_documento, :numero_documento, :data_vencimento, presence: true
      validates :cedente, :endereco_cedente, presence: true
      validates :sacado,  :documento_sacado, presence: true
      validate :data_vencimento_deve_ser_uma_data

      # Passing the attributes as Hash or block
      #
      # @overload initialize(options = {}, &block)
      # @param  [Hash] options Passing a hash accessing the attributes of the self.
      # @option options [String] :cedente
      # @option options [String] :codigo_cedente
      # @option options [String] :documento_cedente
      # @option options [String] :endereco_cedente
      # @option options [String] :conta_corrente
      # @option options [String] :digito_conta_corrente
      # @option options [String] :agencia
      # @option options [Date]   :data_vencimento
      # @option options [String] :numero_documento
      # @option options [Float]  :valor_documento
      # @option options [String] :codigo_moeda
      # @option options [String] :especie
      # @option options [String] :especie_documento
      # @option options [String] :sacado
      # @option options [String] :documento_sacado
      #
      # @param [Proc] block Optional params. Passing a block accessing the attributes of the self.
      #
      # For the options, waiting for the ActiveModel 4 and the ActiveModel::Model. :)
      #
      # === Exemplos
      #
      # O recomendado é usar os boletos herdando de seu respectivo banco. Por exemplo:
      #
      #     class Itau < BoletoBancario::Itau
      #     end
      #
      # Agora você pode emitir um boleto usando a classe criada acima:
      #
      #     Itau.new(conta_corrente: '89755', agencia: '0097', :carteira => '195')
      #
      # Você pode usar blocos se quiser:
      #
      #     Itau.new do |boleto|
      #       boleto.conta_corrente   = '89755'
      #       boleto.agencia          = '0097'
      #       boleto.carteira         = '198'
      #       boleto.numero_documento = '12345678'
      #       boleto.codigo_cedente   = '909014'
      #     end
      #
      def initialize(options={}, &block)
        default_options.merge(options).each do |attribute, value|
          send("#{attribute}=", value) if respond_to?("#{attribute}=")
        end

        yield(self) if block_given?
      end

      # Opções default.
      #
      # Caso queira sobrescrever as opções, você pode simplesmente instanciar o objeto passando a opção desejada:
      #
      #   class Bradesco < BoletoBancario::Bradesco
      #   end
      #
      #   Bradesco.new do |bradesco|
      #     bradesco.codigo_moeda      = 'outro_codigo_da_moeda'
      #     bradesco.especie           = 'outra_especie_que_nao_seja_em_reais'
      #     bradesco.especie_documento = 'outra_especie_do_documento'
      #     bradesco.data_documento    = Date.tomorrow
      #   end
      #
      # @return [Hash] Código da Moeda sendo '9' (real). Espécie sendo 'R$' (real).
      #
      def default_options
        {
          :codigo_moeda      => '9',
          :especie           => 'R$',
          :especie_documento => 'DM',
          :data_documento    => Date.today
        }
      end

      # Código do Banco.
      # <b>Esse campo é específico para cada banco</b>.
      #
      # @return [String] Corresponde ao código do banco.
      #
      # @raise [NotImplementedError] Precisa implementar nas subclasses.
      #
      def codigo_banco
        raise NotImplementedError.new("Not implemented #codigo_banco in #{self}.")
      end

      # Dígito do código do banco.
      # <b>Esse campo é específico para cada banco</b>.
      #
      # @return [String] Corresponde ao dígito do código do banco.
      # @raise [NotImplementedError] Precisa implementar nas subclasses.
      #
      def digito_codigo_banco
        raise NotImplementedError.new("Not implemented #digito_codigo_banco in #{self}.")
      end

      # Agência, código do cedente ou nosso número.
      # <b>Esse campo é específico para cada banco</b>.
      #
      # @return [String] - Corresponde aos campos "Agencia / Codigo do Cedente".
      # @raise [NotImplementedError] Precisa implementar nas subclasses.
      #
      def agencia_codigo_cedente
        raise NotImplementedError.new("Not implemented #agencia_codigo_cedente in #{self}.")
      end

      # O Nosso Número é o número que identifica unicamente um boleto para uma conta.
      # O tamanho máximo do Nosso Número depende do banco e carteira.
      #
      # <b>Para carteiras registradas, você deve solicitar ao seu banco um intervalo de números para utilização.</b>
      # Quando estiver perto do fim do intervalo, deve solicitar um novo intervalo.
      #
      # <b>Para carteiras não registradas o Nosso Número é livre</b>.
      # Ao receber o retorno do banco, é através do Nosso Número que será possível identificar os boletos pagos.
      #
      # <b>Esse campo é específico para cada banco</b>.
      #
      # @return [String] Corresponde ao formato específico de cada banco.
      # @raise [NotImplementedError] Precisa implementar nas subclasses.
      #
      def nosso_numero
        raise NotImplementedError.new("Not implemented #nosso_numero in #{self}.")
      end

      # Formata o valor do documentado para ser mostrado no código de barras
      # e na linha digitável.
      #
      # @example
      #
      #    Bradesco.new(:valor_documento => 123.45).valor_formatado_para_codigo_de_barras
      #    # => "0000012345"
      #
      # @return [String] Precisa retornar 10 dígitos para o código de barras (incluindo os centavos).
      #
      def valor_formatado_para_codigo_de_barras
        valor_documento.to_s.gsub(/\,|\./, '').rjust(10, '0')
      end

      # Embora o padrão seja mostrar o número da carteira no boleto,
      # <b>alguns bancos</b> requerem que seja mostrado um valor diferente na carteira.
      # <b>Para essas exceções, sobrescreva esse método na subclasse.</b>
      #
      # @return [String] retorna o número da carteira
      #
      def carteira_formatada
        carteira
      end

      # Fator de vencimento que é calculado a partir de uma data base.
      # Veja <b>FatorVencimento</b> para mais detalhes.
      #
      # @return [String] 4 caracteres.
      #
      def fator_de_vencimento
        FatorVencimento.new(data_vencimento)
      end

      # === Código de Barras
      #
      # O código de barras contêm exatamente 44 posições nessa sequência:
      #
      #     ____________________________________________________________
      #    | Posição  | Tamanho | Descrição                            |
      #    |----------|---------|--------------------------------------|
      #    | 01-03    |  03     | Código do banco                      |
      #    | 04       |  01     | Código da moeda                      |
      #    | 05       |  01     | Dígito do código de barras (DAC)     |
      #    | 06-09    |  04     | Fator de vencimento                  |
      #    | 10-19    |  10     | Valor do documento                   |
      #    | 20-44    |  25     | Critério de cada Banco (Campo livre) |
      #    -------------------------------------------------------------
      #
      # @return [String] Código de barras com 44 posições.
      #
      def codigo_de_barras
        "#{codigo_de_barras_padrao}#{codigo_de_barras_do_banco}".insert(4, digito_codigo_de_barras)
      end

      # Primeira parte do código de barras.
      # <b>Essa parte do código de barras é padrão para todos os bancos.</b>.
      #
      # @return [String] Primeiras 18 posições do código de barras (<b>Não retorna o DAC do código de barras</b>).
      #
      def codigo_de_barras_padrao
        "#{codigo_banco}#{codigo_moeda}#{fator_de_vencimento}#{valor_formatado_para_codigo_de_barras}"
      end

      # Segunda parte do código de barras.
      # <b>Esse campo é específico para cada banco</b>.
      #
      # @return [String] 25 últimas posições do código de barras.
      # @raise [NotImplementedError] Precisa implementar nas subclasses.
      #
      def codigo_de_barras_do_banco
        raise NotImplementedError.new("Not implemented #codigo_de_barras_do_banco in #{self}.")
      end

      # Dígito verificador do código de barras (DAC).
      #
      # Por definição da FEBRABAN e do Banco Central do Brasil,
      # na <b>5º posição do Código de Barras</b>, deve ser indicado obrigatoriamente
      # o “dígito verificador” (DAC), calculado através do módulo 11.
      #
      # <b>OBS.:</b> Para mais detalhes deste cálculo,
      # veja a descrição em <b>BoletoBancario::Calculos::Modulo11FatorDe2a9</b>.
      #
      # @return [String] Dígito calculado do código de barras.
      #
      def digito_codigo_de_barras
        Modulo11FatorDe2a9.new("#{codigo_de_barras_padrao}#{codigo_de_barras_do_banco}")
      end

      # Representação numérica do código de barras, mais conhecida como linha digitável! :p
      #
      # A representação numérica do código de barras é composta, por cinco campos.
      # Sendo os três primeiros campos, amarrados por DAC's (dígitos verificadores),
      # todos calculados pelo módulo 10.
      #
      # <b>OBS.:</b> Para mais detalhes deste cálculo, veja a descrição em Modulo10.
      #
      # === Linha Digitável
      #
      # A linha digitável contêm exatamente 47 posições nessa sequência:
      #
      #     _______________________________________________________________________________________________________
      #    |Campo | Posição  | Tamanho | Descrição                                                                |
      #    |------|----------|---------|--------------------------------------------------------------------------|
      #    | 1º   | 01-03    |  03     | Código do banco (posições 1 a 3 do código de barras)                     |
      #    |      | 04       |  01     | Código da moeda (posição 4 do código de barras)                          |
      #    |      | 05-09    |  5      | Cinco posições do campo livre (posições 20 a 24 do código de barras)     |
      #    |      | 10       |  1      | Dígito verificador do primeiro campo (Módulo10)                          |
      #    |------------------------------------------------------------------------------------------------------|
      #    | 2º   | 11-20    |  10     | 6º a 15º posições do campo livre (posições 25 a 34 do código de barras)  |
      #    |      | 21       |  01     | Dígito verificador do segundo campo  (Módulo10)                          |
      #    |------------------------------------------------------------------------------------------------------|
      #    | 3º   | 22-31    |  10     | 16º a 25º posições do campo livre (posições 35 a 44 do código de barras) |
      #    |      | 32       |  01     | Dígito verificador do terceiro campo  (Módulo10)                         |
      #    |------------------------------------------------------------------------------------------------------|
      #    | 4º   | 33       |  01     | Dígito verificador do código de barras (posição 5 do código de barras)   |
      #    |------------------------------------------------------------------------------------------------------|
      #    | 5ª   | 34-37    |  04     | Fator de vencimento (posições 6 a 9 do código de barras)                 |
      #    |      | 38-47    |  10     | Valor nominal do documento (posições 10 a 19 do código de barras)        |
      #    -------------------------------------------------------------------------------------------------------|
      #
      # @return [String] Contêm a representação numérica do código de barras formatado com pontos e espaços.
      #
      def linha_digitavel
        LinhaDigitavel.new(codigo_de_barras)
      end

      # Returns a string that <b>identifying the render path associated with the object</b>.
      #
      # <b>ActionPack uses this to find a suitable partial to represent the object.</b>
      #
      # @return [String]
      #
      def to_partial_path
        "boleto_bancario/#{self.class.name.demodulize.underscore}"
      end

      # Seguindo a interface do Active Model.
      #
      # @return [False]
      #
      def persisted?
        false
      end

      # Métodos usado para verificar se deve realizar a validação de tamanho do campo 'agência'.
      # <b>Sobrescreva esse método na subclasse, caso você mesmo queira fazer as validações</b>.
      #
      # @return [True]
      #
      def deve_validar_agencia?
        true
      end

      # Métodos usado para verificar se deve realizar a validação de tamanho do campo 'agência'.
      # <b>Sobrescreva esse método na subclasse, caso você mesmo queira fazer as validações</b>.
      #
      # @return [True]
      #
      def deve_validar_conta_corrente?
        true
      end

      # Métodos usado para verificar se deve realizar a validação de tamanho do campo 'codigo_cedente'.
      # <b>Sobrescreva esse método na subclasse, caso você mesmo queira fazer as validações</b>.
      #
      # @return [True]
      #
      def deve_validar_codigo_cedente?
        true
      end

      # Métodos usado para verificar se deve realizar a validação de tamanho do campo 'numero_documento'.
      # <b>Sobrescreva esse método na subclasse, caso você mesmo queira fazer as validações</b>.
      #
      # @return [True]
      #
      def deve_validar_numero_documento?
        true
      end

      # Métodos usado para verificar se deve realizar a validação de tamanho do campo 'carteira'.
      # <b>Sobrescreva esse método na subclasse, caso você mesmo queira fazer as validações</b>.
      #
      # @return [True]
      #
      def deve_validar_carteira?
        true
      end

      # Verifica e valida se a data do vencimento deve ser uma data válida.
      # <b>Precisa ser uma data para o cálculo do fator do vencimento.</b>
      #
      def data_vencimento_deve_ser_uma_data
        errors.add(:data_vencimento, :invalid) unless data_vencimento.kind_of?(Date)
      end
    end
  end
end