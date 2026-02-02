# frozen_string_literal: true

require 'spec_helper'

class Sicredi < BoletoBancario::Sicredi
  def self.valor_documento_tamanho_maximo
    250 # Default 99999999.99
  end

  def self.carteiras_suportadas
    %w[102] # Default %w[11 31]
  end
end

describe Sicredi do
  describe "on validations" do
    it { is_expected.to have_valid(:valor_documento).when(99, 249, 250) }
    it { is_expected.not_to have_valid(:valor_documento).when(250.01, 260) }

    it { is_expected.to have_valid(:carteira).when(102) }
    it { is_expected.not_to have_valid(:carteira).when(1, 31) }
  end
end
