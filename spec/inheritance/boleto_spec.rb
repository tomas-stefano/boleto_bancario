# frozen_string_literal: true

require 'spec_helper'

class Boleto < BoletoBancario::Boleto
  def self.valor_documento_tamanho_maximo
    9_999.99 # Default 99999999.99
  end
end

describe Boleto do
  describe "on validations" do
    it { is_expected.to have_valid(:valor_documento).when(100.99, 9_999.99) }
    it { is_expected.not_to have_valid(:valor_documento).when(10_000.00, 99_999.99) }
  end
end
