# encoding: utf-8
require 'spec_helper'

class Santander < BoletoBancario::Santander
  def self.valor_documento_tamanho_maximo
    250 # Default 99999999.99
  end

  def self.carteiras_suportadas
    %w[102] # Default %w[101 102 121]
  end
end

describe Santander do
  describe "on validations" do
    it { should have_valid(:valor_documento).when(99, 249, 250) }
    it { should_not have_valid(:valor_documento).when(250.01, 260) }

    it { should have_valid(:carteira).when(102) }
    it { should_not have_valid(:carteira).when(101, 121) }
  end
end
