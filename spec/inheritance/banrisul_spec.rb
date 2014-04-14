# encoding: utf-8
require 'spec_helper'

class Banrisul < BoletoBancario::Banrisul
  def self.valor_documento_tamanho_maximo
    250 # Default 99999999.99
  end

  def self.carteiras_suportadas
    %w[00] # Default %w[00 08]
  end
end

describe Banrisul do
  describe "on validations" do
    it { should have_valid(:valor_documento).when(99, 249, 250) }
    it { should_not have_valid(:valor_documento).when(250.01, 260) }

    it { should have_valid(:carteira).when('00', 0) }
    it { should_not have_valid(:carteira).when('08', 8, 10) }
  end
end
