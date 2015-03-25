# encoding: utf-8
require 'spec_helper'

class Real < BoletoBancario::Real
  def self.valor_documento_tamanho_maximo
    711 # Default 99999999.99
  end

  def self.carteiras_suportadas
    %w[20] # Default %w[00 20 31 42 47 85]
  end
end

describe Real do
  describe "on validations" do
    it { should have_valid(:valor_documento).when(1, 0.01, 711.00) }
    it { should_not have_valid(:valor_documento).when(711.01, 1000) }

    it { should have_valid(:carteira).when(20) }
    it { should_not have_valid(:carteira).when(00, 31, 42, 47, 85) }
  end
end
