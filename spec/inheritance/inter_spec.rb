# frozen_string_literal: true

require 'spec_helper'

module BoletoBancario
  module Core
    describe Inter do
      describe 'on inheritance' do
        subject(:inter_subclass) do
          class InterBoleto < BoletoBancario::Inter
          end
          InterBoleto.new
        end

        it { is_expected.to have_valid(:agencia).when('1234') }
        it { is_expected.not_to have_valid(:agencia).when(nil, '12345') }

        it { is_expected.to have_valid(:conta_corrente).when('12345') }
        it { is_expected.not_to have_valid(:conta_corrente).when(nil, '12345678901') }

        it { is_expected.to have_valid(:numero_documento).when('123456789') }
        it { is_expected.not_to have_valid(:numero_documento).when(nil, '') }

        it { is_expected.to have_valid(:carteira).when('112') }
        it { is_expected.not_to have_valid(:carteira).when(nil, '', '99') }
      end
    end
  end
end
