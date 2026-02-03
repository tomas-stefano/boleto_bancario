# frozen_string_literal: true

module BoletoBancario
  module Calculos
    # Classe responsável pela validação e formatação de documentos (CPF e CNPJ).
    #
    # === Validação de CPF
    #
    # O CPF possui 11 dígitos e é validado através de dois dígitos verificadores
    # calculados pelo módulo 11.
    #
    # === Validação de CNPJ
    #
    # O CNPJ possui 14 dígitos e é validado através de dois dígitos verificadores
    # calculados pelo módulo 11.
    #
    # @example Validação
    #
    #    Documento.valid?('111.444.777-35')
    #    #=> true
    #
    #    Documento.valid?('11.222.333/0001-81')
    #    #=> true
    #
    # @example Formatação
    #
    #    Documento.format('11144477735')
    #    #=> '111.444.777-35'
    #
    #    Documento.format('11222333000181')
    #    #=> '11.222.333/0001-81'
    #
    class Documento
      CPF_SIZE = 11
      CNPJ_SIZE = 14

      # CPF weights for first digit calculation
      CPF_WEIGHTS_FIRST = [10, 9, 8, 7, 6, 5, 4, 3, 2].freeze

      # CPF weights for second digit calculation
      CPF_WEIGHTS_SECOND = [11, 10, 9, 8, 7, 6, 5, 4, 3, 2].freeze

      # CNPJ weights for first digit calculation
      CNPJ_WEIGHTS_FIRST = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2].freeze

      # CNPJ weights for second digit calculation
      CNPJ_WEIGHTS_SECOND = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2].freeze

      class << self
        # Valida se o documento é um CPF ou CNPJ válido.
        #
        # @param [String] documento O documento a ser validado
        # @return [Boolean] true se válido, false caso contrário
        #
        def valid?(documento)
          return false if documento.blank?

          digits = only_digits(documento)

          case digits.size
          when CPF_SIZE
            valid_cpf?(digits)
          when CNPJ_SIZE
            valid_cnpj?(digits)
          else
            false
          end
        end

        # Formata o documento com pontuação.
        #
        # @param [String] documento O documento a ser formatado
        # @return [String] O documento formatado
        #
        def format(documento)
          return documento if documento.blank?

          digits = only_digits(documento)

          case digits.size
          when CPF_SIZE
            format_cpf(digits)
          when CNPJ_SIZE
            format_cnpj(digits)
          else
            documento.to_s
          end
        end

        # Verifica se o documento é um CPF.
        #
        # @param [String] documento O documento a ser verificado
        # @return [Boolean]
        #
        def cpf?(documento)
          only_digits(documento).size == CPF_SIZE
        end

        # Verifica se o documento é um CNPJ.
        #
        # @param [String] documento O documento a ser verificado
        # @return [Boolean]
        #
        def cnpj?(documento)
          only_digits(documento).size == CNPJ_SIZE
        end

        private

        # Remove caracteres não numéricos.
        #
        # @param [String] value
        # @return [String]
        #
        def only_digits(value)
          value.to_s.gsub(/\D/, '')
        end

        # Valida um CPF.
        #
        # @param [String] digits Os 11 dígitos do CPF
        # @return [Boolean]
        #
        def valid_cpf?(digits)
          return false if invalid_sequence?(digits)

          first_digit = calculate_digit(digits[0, 9], CPF_WEIGHTS_FIRST)
          second_digit = calculate_digit(digits[0, 10], CPF_WEIGHTS_SECOND)

          digits[9].to_i == first_digit && digits[10].to_i == second_digit
        end

        # Valida um CNPJ.
        #
        # @param [String] digits Os 14 dígitos do CNPJ
        # @return [Boolean]
        #
        def valid_cnpj?(digits)
          return false if invalid_sequence?(digits)

          first_digit = calculate_digit(digits[0, 12], CNPJ_WEIGHTS_FIRST)
          second_digit = calculate_digit(digits[0, 13], CNPJ_WEIGHTS_SECOND)

          digits[12].to_i == first_digit && digits[13].to_i == second_digit
        end

        # Verifica se todos os dígitos são iguais (sequência inválida).
        #
        # @param [String] digits
        # @return [Boolean]
        #
        def invalid_sequence?(digits)
          digits.chars.uniq.size == 1
        end

        # Calcula um dígito verificador usando módulo 11.
        #
        # @param [String] digits Os dígitos base
        # @param [Array<Integer>] weights Os pesos para multiplicação
        # @return [Integer] O dígito calculado
        #
        def calculate_digit(digits, weights)
          sum = digits.chars.each_with_index.sum do |digit, index|
            digit.to_i * weights[index]
          end

          remainder = sum % 11
          remainder < 2 ? 0 : 11 - remainder
        end

        # Formata CPF com pontuação.
        #
        # @param [String] digits
        # @return [String]
        #
        def format_cpf(digits)
          "#{digits[0, 3]}.#{digits[3, 3]}.#{digits[6, 3]}-#{digits[9, 2]}"
        end

        # Formata CNPJ com pontuação.
        #
        # @param [String] digits
        # @return [String]
        #
        def format_cnpj(digits)
          "#{digits[0, 2]}.#{digits[2, 3]}.#{digits[5, 3]}/#{digits[8, 4]}-#{digits[12, 2]}"
        end
      end
    end
  end
end
