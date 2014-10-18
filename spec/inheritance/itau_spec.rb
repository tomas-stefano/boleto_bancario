# encoding: utf-8
require 'spec_helper'

class Itau < BoletoBancario::Itau
  def self.valor_documento_tamanho_maximo
    250 # Default 99999999.99
  end

  def self.carteiras_suportadas
    %w[109 175 198 131 146 142 168] # Default %w[107 109 174 175 196 198 126 131 146 122 142 143 150 168]
  end
end

describe Itau do
  describe "on validations" do
    it { should have_valid(:valor_documento).when(99, 249, 250) }
    it { should_not have_valid(:valor_documento).when(250.01, 260) }

    it { should have_valid(:carteira).when(109, 175, 198, 131, 146, 142, 168) }
    it { should_not have_valid(:carteira).when(107, 174, 196, 126, 122, 143, 150) }
  end
end
