# encoding: utf-8
require 'spec_helper'

class Sicoob < BoletoBancario::Sicoob
  def self.valor_documento_tamanho_maximo
    456.50 # Default 99999999.99
  end

  def self.carteiras_suportadas
    %w[1] # Default %w[1 9]
  end
end

describe Sicoob do
  describe "on validations" do
    it { should have_valid(:valor_documento).when(99, 99.99, 25) }
    it { should_not have_valid(:valor_documento).when(456.51, 1000) }

    it { should have_valid(:carteira).when(1) }
    it { should_not have_valid(:carteira).when(9) }
  end
end
