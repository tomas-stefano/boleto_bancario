# encoding: utf-8
require 'prawn'
require 'prawn/layout'
require 'prawn/fast_png'
require 'barby'
require 'barby/barcode/code_25_interleaved'
require 'barby/outputter/prawn_outputter'

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

      # Tamanho máximo da carteira.
      # O tamanho máximo é justamente 2 porque no código de barras só é permitido 2 posições para este campo.
      #
      # <b>Método criado justamente para ficar documentado o tamanho máximo aceito até a data corrente.</b>
      #
      # @return [Fixnum] 2
      #
      def self.tamanho_maximo_carteira
        3
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

      # Validações de tamanho para os campos abaixo:
      #
      # * Número do documento
      # * Conta Corrente
      # * Agencia
      # * Carteira
      #
      # Se você quiser sobrescrever os tamanhos permitidos, <b>ficará a sua responsabilidade.</b>
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
      validates :carteira,         length: { maximum: tamanho_maximo_carteira         }, if: :deve_validar_carteira?

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

      # @return [String] 3 caracteres
      #
      def carteira
        @carteira.to_s.rjust(3, '0') if @carteira.present?
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
        "#{agencia}-#{digito_agencia} / #{codigo_cedente}"
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
      # O padrão é zero.
      #
      # @return [String]
      #
      def iof
        return @iof.to_s if @iof.present?

        '0'
      end

      #  === Geração do PDF 
      #
      # Colocando aqui temporariamente para gerar o boleto para homologação o mais rapido possivel
      # TODO: colocar em um modulo de apresentação, para ser usado pelos boletos dos outros bancos

      # Métodos afanados do https://github.com/riopro/kill_bill/blob/master/lib/bank/base.rb:

      TABLE_DEFAULTS = {
        :position => :left,
        :font_size => 8,
        :border_width => 0,
        :align => :left,
        :vertical_padding => 6
      }

      def pdf_parameters(pdf)
        # TODO: move to accessor or find equivalent
        instrucoes = ["Pagável em qualquer agência até o vencimento.", "Após, favor solicitar outro."]

        @barcode = self.barcode
        pdf.font "Helvetica", { :size => 8 }
        # User receipt
        pdf.move_down 86
        data = [ [self.cedente, "#{self.agencia}/#{self.codigo_cedente}", "R$", {:text => "1", :align => :center}, "#{self.nosso_numero}-#{self.digito_nosso_numero}"]]
        pdf.table( data, TABLE_DEFAULTS.merge(:column_widths => { 0 => 270, 1 => 96, 2 => 44, 3 => 40, 4 => 100}) )
        data = [ [self.document_number, self.documento_sacado, self.data_vencimento, self.valor_documento ]]
        pdf.table data, TABLE_DEFAULTS.merge(:column_widths => { 0 => 160, 1 => 120, 2 => 120, 3 => 140 })
        pdf.move_down 16
        pdf.table [[self.sacado]], TABLE_DEFAULTS
        pdf.table [[self.instrucoes[0]]], TABLE_DEFAULTS

        # Bank Compensation Form
        pdf.text_box self.typeable_line(@barcode), :at => [190, 335], :size => 12
        pdf.y = 350
        pdf.table [[self.local_pagamento, self.data_vencimento ]], TABLE_DEFAULTS.merge(:column_widths => { 0 => 450 } )
        pdf.table [["#{self.cedente} - #{self.documento_sacado}", "#{self.agencia}-#{self.digito_agencia}/#{self.codigo_cedente}" ]], TABLE_DEFAULTS.merge(:column_widths => { 0 => 450 } )
        pdf.table [
          [
            self.documented_at.to_s_br,
            self.document_number,
            self.document_specie,
            self.need_acceptation,
            self.processed_at.to_s_br,
            "#{self.carteira}/#{self.nosso_numero}-#{self.digito_nosso_numero}"
          ]
        ], TABLE_DEFAULTS.merge(:column_widths => { 0 => 100, 1 => 100, 2 => 80, 3 => 40, 4 => 100 } )
        pdf.table [["", self.carteira, "R$", 1, self.valor_documento, number_to_currency(self.valor_documento)]], TABLE_DEFAULTS.merge(:column_widths => { 0 => 100, 1 => 100, 2 => 80, 3 => 40, 4 => 100 } )
        y  = 210
        self.instrucoes.each do |instruction|
          pdf.text_box instruction, :at => [5, y]
          y -= pdf.font.height
        end
        pdf.text_box self.sacado, :at => [5, 116]
        pdf.text_box self.endereco_cedente, :at => [5, 106]
        pdf.text_box '', :at => [5, 96]
        # end with barcode
        my_barcode = Barby::Code25Interleaved.new(@barcode)
        my_barcode.annotate_pdf(pdf, { :height => 30, :y => -20, :x => 0, :xdim => 0.8 })
      end

      # You can pass a parameter defining an alternative background image type
      # Possible types are: :png (default) or :jpg
      def to_pdf(background_type=:png)
        @pdf = Prawn::Document.new(:background => File.dirname(__FILE__) + "/../images/#{self.bank.downcase}.#{background_type}")
        self.pdf_parameters(@pdf)
        @pdf.render
      end

      # Render class attributes to pdf file. Saves pdf to the destination
      # setted in the filename parameter
      # You could pass a parameter defining an alternative background image type
      # Possible types are: :png (default) or :jpg
      def to_pdf_file(filename = nil, background_type=:png)
        Prawn::Document.generate(filename, :background => File.dirname(__FILE__) + "/../images/#{self.bank.downcase}.#{background_type}") do |pdf|
          self.pdf_parameters(pdf)
        end
      end
    end
  end
end