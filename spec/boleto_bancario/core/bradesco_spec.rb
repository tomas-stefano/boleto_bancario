# encoding: utf-8
require 'spec_helper'

module BoletoBancario
  module Core
    describe Bradesco do
      it_should_behave_like 'boleto bancario'

      describe "on validations" do
        it { should have_valid(:agencia).when('1', '123', '1234') }
        it { should_not have_valid(:agencia).when('12345', '123456', '1234567', nil, '') }

        it { should have_valid(:conta_corrente).when('1', '123', '1234') }
        it { should_not have_valid(:conta_corrente).when('12345678', '123456789', nil, '') }

        it { should have_valid(:numero_documento).when(12345678911, '12345678911', '13') }
        it { should_not have_valid(:numero_documento).when('', nil, 123456789112, 1234567891113) }

        it { should have_valid(:carteira).when('03', '06', '09', '19', '21', '22', 3, 9, 19, 21, 22) }
        it { should_not have_valid(:carteira).when(nil, '', '05', '20', '100') }

        it { should have_valid(:valor_documento).when(1, 1.99, 100.99, 99_999_999.99, '100.99') }
        it { should_not have_valid(:valor_documento).when(nil, '', '100,99', 100_000_000.99) }
      end

      describe "#agencia" do
        context "when have a value" do
          subject { Bradesco.new(:agencia => 2) }

          it { expect(subject.agencia).to eq '0002' }
        end

        context "when is nil" do
          it { expect(subject.agencia).to be nil }
        end
      end

      describe "#conta_corrente" do
        context "when have a value" do
          subject { Bradesco.new(:conta_corrente => 1) }

          it { expect(subject.conta_corrente).to eq '0000001' }
        end

        context "when is nil" do
          it { expect(subject.conta_corrente).to be nil }
        end
      end

      describe "#numero_documento" do
        context "when have a value" do
          subject { Bradesco.new(:numero_documento => 1234) }

          it { expect(subject.numero_documento).to eq '00000001234' }
        end

        context "when is nil" do
          it { expect(subject.numero_documento).to be nil }
        end
      end

      describe "#carteira" do
        context "when have a value" do
          subject { Bradesco.new(:carteira => 3) }

          it { expect(subject.carteira).to eq '03' }
        end

        context "when is nil" do
          it { expect(subject.carteira).to be nil }
        end
      end

      describe "#carteira_formatada" do
        context "when carteira is '21'" do
          subject { Bradesco.new(:carteira => 21) }

          it { expect(subject.carteira_formatada).to eq '21 – Cobrança Interna Com Registro' }
        end

        context "when carteira is '22'" do
          subject { Bradesco.new(:carteira => 22) }

          it { expect(subject.carteira_formatada).to eq '22 – Cobrança Interna sem registro' }
        end

        context "when carteira is '03'" do
          subject { Bradesco.new(:carteira => 3) }

          it { expect(subject.carteira_formatada).to eq '03' }
        end
      end

      describe "#codigo_banco" do
        it { expect(subject.codigo_banco).to eq '237' }
      end

      describe "#digito_codigo_banco" do
        it { expect(subject.digito_codigo_banco).to eq '2' }
      end

      describe "#agencia_codigo_cedente" do
        subject { Bradesco.new(agencia: '1172', conta_corrente: '0403005') }

        it { expect(subject.agencia_codigo_cedente).to eq '1172-10 / 0403005-2' }
      end

      describe "#nosso_numero" do
        context "documentation example" do
          subject { Bradesco.new(:carteira => '19', :numero_documento => '00000000002') }

          it { expect(subject.nosso_numero).to eq '19/00000000002-8' }
        end

        context "more examples from documentation" do
          subject { Bradesco.new(:carteira => '19', :numero_documento => '00000000001') }

          it { expect(subject.nosso_numero).to eq '19/00000000001-P' }
        end

        context "more examples" do
          subject { Bradesco.new(:carteira => '06', :numero_documento => '00075896452') }

          it { expect(subject.nosso_numero).to eq '06/00075896452-5' }
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
              boleto.conta_corrente        = 403005
            end
          end

          it { expect(subject.codigo_de_barras).to eq '23796556100002952951172060007589645204030050' }
          it { expect(subject.linha_digitavel).to eq '23791.17209 60007.589645 52040.300502 6 55610000295295' }
        end

        context "when carteira '09'" do
          subject do
            Bradesco.new do |boleto|
              boleto.carteira              = 9
              boleto.numero_documento      = 175896451
              boleto.valor_documento       = 2959.78
              boleto.data_vencimento       = Date.parse('2012-12-28')
              boleto.agencia               = 1172
              boleto.conta_corrente        = 403005
            end
          end

          it { expect(subject.codigo_de_barras).to eq '23791556100002959781172090017589645104030050' }
          it { expect(subject.linha_digitavel).to eq '23791.17209 90017.589640 51040.300504 1 55610000295978' }
        end
      end
    end
  end
end
