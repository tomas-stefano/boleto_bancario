# encoding: utf-8
module BoletoBancario
  module Core
    # Implementação de emissão de boleto bancário pelo Banco do Brasil.
    #
    # === Documentação Implementada
    #
    # A documentação na qual essa implementação foi baseada está localizada na pasta
    # 'documentacoes_dos_boletos/banco_brasil' dentro dessa biblioteca.
    #
    # === Experimental
    #
    # O Boleto do Banco do Brasil ainda está categorizado como experimental. POr favor ajude a validar e homologar
    # esse banco para as carteiras suportadas conforme descrito abaixo.
    #
    # === Contrato das classes de emissão de boletos
    #
    # Para ver o "<b>contrato</b>" da Emissão de Boletos (geração de código de barras, linha digitável, etc) veja
    # a classe BoletoBancario::Core::Boleto.
    #
    # === Carteiras suportadas
    #
    # Segue abaixo as carteiras suportadas do Banco do Brasil <b>seguindo a documentação</b>:
    #
    #    ________________________________________________________________________________________________________
    #   | Carteira | Descrição                                                    | Testada/Homologada no banco |
    #   |   12     | Código do cedente de 6 dígitos                               | Esperando Contribuição      |
    #   |   16     | Código do cedente de 6 dígitos e nosso numero com 17 dígitos | Esperando Contribuição      |
    #   |   16     | Código do cedente de 4 dígitos                               | Esperando Contribuição      |
    #   |   16     | Código do cedente de 6 dígitos                               | Esperando Contribuição      |
    #   |   17     | Código do cedente de 7 dígitos                               | Esperando Contribuição      |
    #   |   17     | Código do cedente de 8 dígitos                               | Esperando Contribuição      |
    #   |   18     | Código do cedente de 4 dígitos                               | Esperando Contribuição      |
    #   |   18     | Código do cedente de 6 dígitos                               | Esperando Contribuição      |
    #   |   18     | Código do cedente de 6 dígitos e nosso numero com 17 dígitos | Esperando Contribuição      |
    #   |   18     | Código do cedente de 7 dígitos                               | Esperando Contribuição      |
    #   |   18     | Código do cedente de 8 dígitos                               | Esperando Contribuição      |
    #   ---------------------------------------------------------------------------------------------------------
    #
    # # <b>OBS.: Seja um contribuidor dessa gem. Contribua para homologar os boletos e as
    # devidas carteiras junto ao banco Bradesco.</b>
    #
    class BancoBrasil < Boleto
      # Tamanho máximo de uma agência no Banco do Brasil.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 4
      #
      def self.tamanho_maximo_agencia
        4
      end

      # Tamanho máximo de uma conta corrente no Banco do Brasil.
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 8
      #
      def self.tamanho_maximo_conta_corrente
        8
      end

      # <b>Tamanho máximo do número do documento emitido no Boleto, quando o código do cedente tiver 4 dígitos.</b>
      #
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 7
      #
      def self.tamanho_maximo_numero_documento_com_codigo_cedente_quatro_digitos
        7
      end

      # <b>Tamanho máximo do número do documento emitido no Boleto, quando o código do cedente tiver 6 dígitos.</b>
      #
      # === Convenção
      #
      # Sempre que você for usar o número do documento com 17 dígitos nas carteiras 16 ou 18 com
      # código cedente de 6 dígitos, <b>fica a seu cargo colocar os 17 dígitos do número do documento</b>.
      #
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 17 ou 5
      #
      #
      def self.tamanho_maximo_numero_documento_com_codigo_cedente_seis_digitos
        5
      end

      # <b>Tamanho máximo do número do documento emitido no Boleto, quando o código do cedente tiver 7 dígitos.</b>
      #
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 10
      #
      def self.tamanho_maximo_numero_documento_com_codigo_cedente_sete_digitos
        10
      end

      # <b>Tamanho máximo do número do documento emitido no Boleto, quando o código do cedente tiver 8 dígitos.</b>
      #
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 9
      #
      def self.tamanho_maximo_numero_documento_com_codigo_cedente_oito_digitos
        9
      end

      # <b>Tamanho máximo do número do documento emitido no Boleto, quando o código do cedente tiver 6 dígitos,
      # ser carteira 16 ou 18 e ter o nosso número com 17 dígitos.</b>
      #
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 9
      #
      def self.tamanho_maximo_numero_documento_dezessete_digitos
        17
      end

      validates :codigo_cedente, :agencia, :digito_agencia, :conta_corrente, :digito_conta_corrente, presence: true

      validates :digito_agencia,        length: { maximum: 1  }
      validates :digito_conta_corrente, length: { maximum: 1  }

      # Validações de Agencia e Conta corrente.
      #
      validates :agencia,          length: { maximum: tamanho_maximo_agencia        }, if: :deve_validar_agencia?
      validates :conta_corrente,   length: { maximum: tamanho_maximo_conta_corrente }, if: :deve_validar_conta_corrente?

      # Validações do número do documento.
      #
      # === Número do Documento e Código do Cedente.
      #
      # A validação do número do documento, varia, dependendo da quantidade de dígitos do código do cedente.
      #
      # <b>Para mais detalhes, veja o método #numero_documento, para entender essas validações</b>.
      #
      validates :numero_documento, length: { maximum: tamanho_maximo_numero_documento_com_codigo_cedente_quatro_digitos }, if: :deve_validar_com_codigo_cedente_quatro_digitos?
      validates :numero_documento, length: { maximum: tamanho_maximo_numero_documento_com_codigo_cedente_sete_digitos   }, if: :deve_validar_com_codigo_cedente_sete_digitos?
      validates :numero_documento, length: { maximum: tamanho_maximo_numero_documento_com_codigo_cedente_oito_digitos   }, if: :deve_validar_com_codigo_cedente_oito_digitos?

      # Possui 2 tipos de validações de código do cedente com 6 dígitos:
      #
      # 1) Quando for nosso número com onze posições (6 do código cedente + 5 do número do documento).
      # 2) Quando for nosso número com dezessete posições (17 do número do documento).
      #
      #
      validates :numero_documento, length: { maximum: tamanho_maximo_numero_documento_com_codigo_cedente_seis_digitos   }, if: :deve_validar_com_codigo_cedente_seis_digitos?
      validates :numero_documento, length: { maximum: tamanho_maximo_numero_documento_dezessete_digitos                 }, if: :deve_validar_com_nosso_numero_dezessete_digitos?

      validate :validacao_tamanho_de_digitos_codigo_cedente,   if: :deve_validar_codigo_cedente?

      # @return [String] 4 caracteres
      #
      def agencia
        @agencia.to_s.rjust(4, '0') if @agencia.present?
      end

      # @return [String] 8 caracteres
      #
      def conta_corrente
        @conta_corrente.to_s.rjust(8, '0') if @conta_corrente.present?
      end

      # === Número do Documento VS. Código do Cedente
      #
      # No caso do Banco do Brasil, o tamanho do código do cedente ditará o tamanho do número do documento.
      # Ou seja, <b>quando o código do cedente for X, o tamanho do número do documento deverá ser Y</b>.
      # Segue abaixo:
      #
      #     ______________________________________________________________
      #    | Tamanho do Código Cedente  | Tamanho do Número do documento |
      #    |----------------------------|--------------------------------|
      #    |          04                |           07                   |
      #    |          06                |           05                   |
      #    |          07                |           10                   |
      #    |          08                |           09                   |
      #    ---------------------------------------------------------------
      #
      # <b>OBS.: Quando o tamanho do código do cedente for 6, o número do documento
      # pode ter 17 dígitos, se for usado com a carteira 16 ou 18.</b>
      #
      # @return [String]
      #
      def numero_documento
        if @numero_documento.present?
          @numero_documento.to_s.rjust(numero_documento_esperado[tamanho_codigo_cedente], '0')
        else
          @numero_documento
        end
      end

      # Para ficar documentado preferi criar um método onde retorna o tamanho esperado
      # do número do documento dependendo do tamanho do código do cedente.
      #
      # <b>Para mais detalhes veja o método #numero_documento dessa classe.</b>
      #
      # @return [Hash] As chaves significam o tamanho do código cedente e o valor o tamanho esperado do número do documento.
      #
      def numero_documento_esperado
        { 0 => 0, 4 => 7, 6 => 5, 7 => 10, 8 => 9 }
      end

      # @return [String] Código do Banco descrito na documentação.
      #
      def codigo_banco
        '001'
      end

      # Dígito do código do banco. Precisa mostrar esse dígito no boleto.
      #
      # @return [String] Dígito do código do banco descrito na documentação.
      #
      def digito_codigo_banco
        '9'
      end

      # Campo Agencia / Código do Cedente
      # Retorna formatado a agência, digito da agência, número da conta corrente e dígito da conta.
      #
      # @return [String]
      #
      def agencia_codigo_cedente
        "#{agencia}-#{digito_agencia} / #{conta_corrente}-#{digito_conta_corrente}"
      end

      # === Composição do nosso número
      #
      # ==== Código do Cedente de 4 dígitos
      #
      #     ___________________________________________________________
      #    | Posição  | Tamanho | Descrição                           |
      #    |----------|---------|-------------------------------------|
      #    | 01-04    |  04     | Código do cedente de 4 dígitos      |
      #    | 05-11    |  07     | Nosso número livre do cliente       |
      #    | 12       |  01     | Dígito Verificador do Nosso número  |
      #    ------------------------------------------------------------
      #
      # ==== Código do Cedente de 6 dígitos
      #
      #     ___________________________________________________________
      #    | Posição  | Tamanho | Descrição                           |
      #    |----------|---------|-------------------------------------|
      #    | 01-06    |  06     | Código do cedente de 6 dígitos      |
      #    | 07-11    |  05     | Nosso número livre do cliente       |
      #    | 12       |  01     | Dígito Verificador do Nosso número  |
      #    ------------------------------------------------------------
      #
      # ==== Código do Cedente de 7 dígitos
      #
      #     ___________________________________________________________
      #    | Posição  | Tamanho | Descrição                           |
      #    |----------|---------|-------------------------------------|
      #    | 01-07    |  07     | Código do cedente de 7 dígitos      |
      #    | 08-17    |  10     | Nosso número livre do cliente       |
      #    ------------------------------------------------------------
      #
      # <b>Obs.: Não existe Dígito Verificador na composição do nosso-número para convênios
      # de sete posições.</b>
      #
      # ==== Código do Cedente de 8 dígitos
      #
      #     ___________________________________________________________
      #    | Posição  | Tamanho | Descrição                           |
      #    |----------|---------|-------------------------------------|
      #    | 01-08    |  08     | Código do cedente de 7 dígitos      |
      #    | 09-17    |  09     | Nosso número livre do cliente       |
      #    ------------------------------------------------------------
      #
      # <b>Obs.: Não existe Dígito Verificador na composição do nosso-número para convênios
      # de oito posições.</b>
      #
      # @return [String] Nosso número que será mostrado no boleto
      #
      def nosso_numero
        if codigo_cedente_oito_digitos? or codigo_cedente_sete_digitos?
          "#{codigo_cedente}#{numero_documento}"
        else
          "#{codigo_cedente}#{numero_documento}-#{digito_nosso_numero}"
        end
      end

      # Para o cálculo do dígito, será necessário acrescentar o código do cedente e
      # Nosso Número (número do documento), e aplicar o módulo 11, com fatores de 9 a 2
      # verificando o resto da divisão.
      #
      # <b>Para mais detalhes de como o cálculo é feito veja a classe Modulo11FatorDe9a2RestoX.</b>
      #
      # @return [String] Retorno do cálculo do módulo 11 com os fatores (9,8,7,6,5,4,3,2).
      #
      def digito_nosso_numero
        Modulo11FatorDe9a2RestoX.new("#{codigo_cedente}#{numero_documento}")
      end

      # === Código do cedente com 4 dígitos
      #
      # Quando o código do cedente possui 4 dígitos o formato do código de barras deve ficar assim:
      #
      #     __________________________________________________________________________
      #    | Posição  | Tamanho | Descrição                                          |
      #    |----------|---------|----------------------------------------------------|
      #    | 20-30    |  11     | Nosso-Número, sem dígito verificador               |
      #    |       20-23        | Código do cedente fornecido pelo Banco (4 dígitos) |
      #    |       24-30        | Nosso-Número, sem dígito verificador (7 dígitos)   |
      #    | 31-34    |  04     | Agência (sem o dígito)                             |
      #    | 35-42    |  08     | Conta corrente (sem o dígito)                      |
      #    | 43-44    |  02     | Carteira                                           |
      #    ---------------------------------------------------------------------------
      #
      # === Código do cedente com 6 dígitos
      #
      # Quando o código do cedente possui 6 dígitos o formato do código de barras deve ficar assim:
      #
      #     __________________________________________________________________________
      #    | Posição  | Tamanho | Descrição                                          |
      #    |----------|---------|----------------------------------------------------|
      #    | 20-30    |  11     | Nosso-Número, sem dígito verificador               |
      #    |       20-25        | Código do cedente fornecido pelo Banco (6 dígitos) |
      #    |       26-30        | Nosso-Número, sem dígito verificador (5 dígitos)   |
      #    | 31-34    |  04     | Agência (sem o dígito)                             |
      #    | 35-42    |  08     | Conta corrente (sem o dígito)                      |
      #    | 43-44    |  02     | Carteira                                           |
      #    ---------------------------------------------------------------------------
      #
      # === Código do cedente com 7 dígitos
      #
      # Quando o código do cedente possui 7 dígitos o formato do código de barras deve ficar assim:
      #
      #     __________________________________________________________________________
      #    | Posição  | Tamanho | Descrição                                          |
      #    |----------|---------|----------------------------------------------------|
      #    | 20-30    |  17     | Nosso-Número, sem dígito verificador               |
      #    |       20-32        | Código do cedente fornecido pelo Banco (7 dígitos) |
      #    |       33-42        | Nosso-Número, sem dígito verificador (10 dígitos)  |
      #    | 43-44    |  02     | Carteira                                           |
      #    ---------------------------------------------------------------------------
      #
      # === Código do cedente com 8 dígitos
      #
      # Quando o código do cedente possui 8 dígitos o formato do código de barras deve ficar assim:
      #
      #     __________________________________________________________________________
      #    | Posição  | Tamanho | Descrição                                          |
      #    |----------|---------|----------------------------------------------------|
      #    | 20-30    |  17     | Nosso-Número, sem dígito verificador               |
      #    |       20-33        | Código do cedente fornecido pelo Banco (8 dígitos) |
      #    |       34-42        | Nosso-Número, sem dígito verificador (9 dígitos)   |
      #    | 43-44    |  02     | Carteira                                           |
      #    ---------------------------------------------------------------------------
      #
      # === Carteiras 16 e 18, código do cedente de 6 posições, nosso número com 17 dígitos.
      #
      # Código do cedente possui 6 dígitos, nosso número com 17 dígitos e a carteira for 16 ou 18,
      # o formato do código de barras deve ficar assim:
      #
      #     ___________________________________________________________
      #    | Posição  | Tamanho | Descrição                           |
      #    |----------|---------|-------------------------------------|
      #    | 20-25    |  6      | Código do cedente de 6 dígitos      |
      #    | 26-42    |  17     | Nosso número livre do cliente       |
      #    | 43-44    |  02     | "21" Tipo da modalidade de cobranca |
      #    ------------------------------------------------------------
      #
      def codigo_de_barras_do_banco
        if nosso_numero_dezessete_posicoes?
          return codigo_de_barras_codigo_cedente_seis_posicoes_nosso_numero_dezessete_posicoes
        end

        if codigo_cedente_quatro_digitos? or codigo_cedente_seis_digitos?
          return codigo_de_barras_codigo_cedente_quatro_ou_seis_digitos
        end

        if codigo_cedente_sete_digitos? or codigo_cedente_oito_digitos?
          codigo_de_barras_codigo_cedente_sete_ou_oito_digitos
        end
      end

      # Retorna o código de barras do campo livre para emissão de boletos com:
      #
      # <b>Nosso número de 11 posições - EXCLUSIVO PARA CONVÊNIOS DE SEIS POSIÇÕES.</b>
      #
      # @return [String]
      #
      def codigo_de_barras_codigo_cedente_quatro_ou_seis_digitos
        "#{codigo_cedente}#{numero_documento}#{agencia}#{conta_corrente}#{carteira}"
      end

      # Retorna o código de barras do campo livre para emissão de boletos com:
      #
      # <b>Carteira 17 e 18 - VINCULADOS À CONVÊNIOS COM NUMERAÇÃO SUPERIOR A 1.000.000 (um milhão).</b>
      #
      # @return [String]
      #
      def codigo_de_barras_codigo_cedente_sete_ou_oito_digitos
        "000000#{codigo_cedente}#{numero_documento}#{carteira}"
      end

      # Retorna o código de barras do campo livre para emissão de bloquetos com:
      #
      # <b>Nosso número de 17 posições - EXCLUSIVO PARA AS CARTEIRAS 16 E 18, VINCULADAS À CONVÊNIOS COM SEIS POSIÇÕES.</b>
      #
      # @return [String]
      #
      def codigo_de_barras_codigo_cedente_seis_posicoes_nosso_numero_dezessete_posicoes
        "#{codigo_cedente}#{numero_documento}#{modalidade_de_cobranca}"
      end

      # Modalidade de cobranca definida pelo Banco do Brasil para ser mostrado no código de barras
      # com código de cedente de seis posições e nosso número de 17 posições, carteira 16 e 18.
      #
      # @return [String] 21
      #
      def modalidade_de_cobranca
        "21"
      end

      # Verifica se o código do cedente possui 4 dígitos.
      #
      # @return [true, false]
      #
      def codigo_cedente_quatro_digitos?
        tamanho_codigo_cedente == 4
      end

      # Verifica se o código do cedente possui 6 dígitos.
      #
      # @return [true, false]
      #
      def codigo_cedente_seis_digitos?
        tamanho_codigo_cedente == 6
      end

      # Verifica se o código do cedente possui 7 dígitos.
      #
      # @return [true, false]
      #
      def codigo_cedente_sete_digitos?
        tamanho_codigo_cedente == 7
      end

      # Verifica se o código do cedente possui 8 dígitos.
      #
      # @return [true, false]
      #
      def codigo_cedente_oito_digitos?
        tamanho_codigo_cedente == 8
      end

      # Retorna o tamanho do campo código do cedente.
      # Super importante para o número do documento e e para o código de barras
      #
      # @return [Fixnum] Tamanho do campo código do cedente.
      #
      def tamanho_codigo_cedente
        codigo_cedente.to_s.size
      end

      # Verifica se:
      #
      # * Número do documento possui 17 dígitos
      # * Carteira está habilitada para usar 17 dígitos do número documento.
      # * Código do Cedente está habilitado para usar 17 dígitos do número documento (se tiver 6 dígitos).
      #
      # @return [true, false]
      #
      def nosso_numero_dezessete_posicoes?
        codigo_cedente_seis_digitos? and carteira.to_s.in?(carteiras_nosso_numero_dezessete_posicoes) and numero_documento.to_s.size == 17
      end

      # Retorna as carteiras que aceitam nosso número com 17 posições.
      #
      # @return [Array]
      #
      def carteiras_nosso_numero_dezessete_posicoes
        %w(16 18)
      end

      # Verifica se o campo código do cedente tem o tamanho suportado pelo Banco do Brasil.
      #
      def validacao_tamanho_de_digitos_codigo_cedente
        errors.add(:codigo_cedente, :invalid) unless tamanho_codigo_cedente.in?(tamanhos_codigo_cedente_suportado)
      end

      # Retorna os tamanhos do código do cedente suportados pelo Banco do Brasil.
      #
      # @return [Array]
      #
      def tamanhos_codigo_cedente_suportado
        [4, 6, 7, 8]
      end

      # Método que pode ser sobrescrito na subclasse se você <b>não quiser</b> que essa validação ocorra.
      #
      # <b>Lembre-se que fica a seu critério, mudar as validações da gem</b>.
      #
      def deve_validar_com_codigo_cedente_quatro_digitos?
        deve_validar_codigo_cedente? and codigo_cedente_quatro_digitos?
      end

      # Método que pode ser sobrescrito na subclasse se você <b>não quiser</b> que essa validação ocorra.
      #
      # <b>Lembre-se que fica a seu critério, mudar as validações da gem</b>.
      #
      def deve_validar_com_codigo_cedente_seis_digitos?
        deve_validar_codigo_cedente? and codigo_cedente_seis_digitos? and not nosso_numero_dezessete_posicoes?
      end

      # Método que pode ser sobrescrito na subclasse se você <b>não quiser</b> que essa validação ocorra.
      #
      # <b>Lembre-se que fica a seu critério, mudar as validações da gem</b>.
      #
      def deve_validar_com_nosso_numero_dezessete_digitos?
        deve_validar_codigo_cedente? and codigo_cedente_seis_digitos? and nosso_numero_dezessete_posicoes?
      end

      # Método que pode ser sobrescrito na subclasse se você <b>não quiser</b> que essa validação ocorra.
      #
      # <b>Lembre-se que fica a seu critério, mudar as validações da gem</b>.
      #
      def deve_validar_com_codigo_cedente_sete_digitos?
        deve_validar_codigo_cedente? and codigo_cedente_sete_digitos?
      end

      # Método que pode ser sobrescrito na subclasse se você <b>não quiser</b> que essa validação ocorra.
      #
      # <b>Lembre-se que fica a seu critério, mudar as validações da gem</b>.
      #
      def deve_validar_com_codigo_cedente_oito_digitos?
        deve_validar_codigo_cedente? and codigo_cedente_oito_digitos?
      end
    end
  end
end