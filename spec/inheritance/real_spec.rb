# encoding: utf-8
require 'spec_helper'

class Real < BoletoBancario::Real
  def self.valor_documento_tamanho_maximo
    711 # Default 99999999.99
  end

  def carteira
    '12' # Default 20
  end
end

describe Real do
  describe "on validations" do
    it { should have_valid(:valor_documento).when(1, 0.01, 711.00) }
    it { should_not have_valid(:valor_documento).when(711.01, 1000) }

    its(:carteira) { should eq '12' }
  end
end
