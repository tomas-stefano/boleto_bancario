# encoding: utf-8
require 'spec_helper'

module BoletoBancario
  module Core
    describe Bradesco do
      it_should_behave_like 'boleto bancario'

      describe "on validations" do
        it { should have_valid(:agencia).when('1', '123', '1234') }
        it { should_not have_valid(:agencia).when('12345', '123456', '1234567', nil, '') }

        it { should have_valid(:digito_agencia).when('1', 'X', '4') }
        it { should_not have_valid(:digito_agencia).when(nil, '', '12', '123') }

        it { should have_valid(:conta_corrente).when('1', '123', '1234') }
        it { should_not have_valid(:conta_corrente).when('12345678', '123456789', nil, '') }

        it { should have_valid(:digito_conta_corrente).when('1', '4', 'X') }
        it { should_not have_valid(:digito_conta_corrente).when(nil, '', '12', '123') }

        it { should have_valid(:carteira).when(6, '6', '13') }
        it { should_not have_valid(:carteira).when('', nil, '102', '123') }

        it { should have_valid(:numero_documento).when(12345678911, '12345678911', '13') }
        it { should_not have_valid(:numero_documento).when('', nil, 123456789112, 1234567891113) }
      end

      describe "#agencia" do
        context "when have a value" do
          subject { Bradesco.new(:agencia => 2) }

          its(:agencia) { should eq '0002' }
        end

        context "when is nil" do
          its(:agencia) { should be nil }
        end
      end

      describe "#conta_corrente" do
        context "when have a value" do
          subject { Bradesco.new(:conta_corrente => 1) }

          its(:conta_corrente) { should eq '0000001' }
        end

        context "when is nil" do
          its(:conta_corrente) { should be nil }
        end
      end

      describe "#numero_documento" do
        context "when have a value" do
          subject { Bradesco.new(:numero_documento => 1234) }

          its(:numero_documento) { should eq '00000001234' }
        end

        context "when is nil" do
          its(:numero_documento) { should be nil }
        end
      end

      describe "#carteira" do
        context "when have a value" do
          subject { Bradesco.new(:carteira => 3) }

          its(:carteira) { should eq '03' }
        end

        context "when is nil" do
          its(:carteira) { should be nil }
        end
      end

      describe "#carteira_formatada" do
        context "when carteira is '21'" do
          subject { Bradesco.new(:carteira => 21) }

          its(:carteira_formatada) { should eq '21 – Cobrança Interna Com Registro' }
        end

        context "when carteira is '22'" do
          subject { Bradesco.new(:carteira => 22) }

          its(:carteira_formatada) { should eq '22 – Cobrança Interna sem registro' }
        end

        context "when carteira is '03'" do
          subject { Bradesco.new(:carteira => 3) }

          its(:carteira_formatada) { should eq '03' }
        end
      end

      describe "#codigo_banco" do
        its(:codigo_banco) { should eq '237' }
      end

      describe "#digito_codigo_banco" do
        its(:digito_codigo_banco) { should eq '2' }
      end

      describe "#agencia_codigo_cedente" do
        subject { Bradesco.new(agencia: '1172', digito_agencia: '0', conta_corrente: '0403005', digito_conta_corrente: '2') }

        its(:agencia_codigo_cedente) { should eq '1172-0 / 0403005-2'}
      end

      describe "#nosso_numero" do
        context "documentation example" do
          subject { Bradesco.new(:carteira => '19', :numero_documento => '00000000002') }

          its(:nosso_numero) { should eq '19/00000000002-8' }
        end

        context "more examples from documentation" do
          subject { Bradesco.new(:carteira => '19', :numero_documento => '00000000001') }

          its(:nosso_numero) { should eq '19/00000000001-P' }
        end

        context "more examples" do
          subject { Bradesco.new(:carteira => '06', :numero_documento => '00075896452') }

          its(:nosso_numero) { should eq '06/00075896452-5' }
        end
      end

      describe "#codigo_de_barras" do
        context "more examples" do
          subject do
            Bradesco.new do |boleto|
              boleto.carteira              = 6
              boleto.numero_documento      = 75896452
              boleto.valor_documento       = 2952.95
              boleto.data_vencimento       = Date.parse('2012-12-28')
              boleto.agencia               = 1172
              boleto.digito_agencia        = 0
              boleto.conta_corrente        = 403005
              boleto.digito_conta_corrente = 2
            end
          end

          its(:codigo_de_barras) { should eq '23796556100002952951172060007589645204030050' }
          its(:linha_digitavel)  { should eq '23791.17209 60007.589645 52040.300502 6 55610000295295' }
        end

        context "when carteira '09'" do
          subject do
            Bradesco.new do |boleto|
              boleto.carteira              = 9
              boleto.numero_documento      = 175896451
              boleto.valor_documento       = 2959.78
              boleto.data_vencimento       = Date.parse('2012-12-28')
              boleto.agencia               = 1172
              boleto.digito_agencia        = 0
              boleto.conta_corrente        = 403005
              boleto.digito_conta_corrente = 2
            end
          end

          its(:codigo_de_barras) { should eq '23791556100002959781172090017589645104030050' }
          its(:linha_digitavel) { should eq '23791.17209 90017.589640 51040.300504 1 55610000295978' }
        end
      end
    end
  end
end