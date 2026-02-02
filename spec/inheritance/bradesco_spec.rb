# frozen_string_literal: true

require 'spec_helper'

class Bradesco < BoletoBancario::Bradesco
  def self.valor_documento_tamanho_maximo
    250 # Default 99999999.99
  end

  def self.carteiras_suportadas
    %w[06 19 22] # Default %w[03 06 09 19 21 22]
  end
end

describe Bradesco do
  describe "on validations" do
    it { is_expected.to have_valid(:valor_documento).when(99, 249, 250) }
    it { is_expected.not_to have_valid(:valor_documento).when(250.01, 260) }

    it { is_expected.to have_valid(:carteira).when(6, 19, 22) }
    it { is_expected.not_to have_valid(:carteira).when(3, 9, 21, 15) }
  end
end
