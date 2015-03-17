# encoding: utf-8
require 'spec_helper'

class Caixa < BoletoBancario::Caixa
  def self.valor_documento_tamanho_maximo
    100 # Default 9999999.99
  end

  def self.carteiras_suportadas
    %w[12 17] # Default %w[14 24]
  end
end

describe Caixa do
  describe "on validations" do
    it { should have_valid(:valor_documento).when(99, 99.99, 25) }
    it { should_not have_valid(:valor_documento).when(100.01, 150) }

    it { should have_valid(:carteira).when(12, 17) }
    it { should_not have_valid(:carteira).when(16, 14, 20) }
  end
end
