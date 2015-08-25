# encoding: utf-8
require 'spec_helper'

module BoletoBancario
  module Core
    describe BancoBrasil do
      it_should_behave_like 'boleto bancario'

      describe "on validations" do
        context "#agencia" do
          it { should have_valid(:agencia).when('123', '1234') }
          it { should_not have_valid(:agencia).when('12345', '123456', nil, '') }
        end

        context "#conta_corrente" do
          it { should have_valid(:conta_corrente).when('12345678', '12345', '1234') }
          it { should_not have_valid(:conta_corrente).when('123456789', nil, '') }
        end

        context "#codigo_cedente" do
          it { should have_valid(:codigo_cedente).when('1234', '123456', '1234567', '12345678') }
          it { should_not have_valid(:codigo_cedente).when('123', '1', '12', nil, '') }
        end

        context "#carteira" do
          it { should have_valid(:carteira).when('12', '16', '17', '18', 12, 18) }
          it { should_not have_valid(:carteira).when(nil, '', '5', '20', '100', 14, 19) }
        end

        describe "#valor_documento" do
          it { should have_valid(:valor_documento).when(1, 1.99, 100.99, 99_999_999.99, '100.99') }
          it { should_not have_valid(:valor_documento).when(nil, '', '100,99', 100_000_000.99) }
        end

        context "when 'carteira' is 16 and 'codigo_cedente' 6 digits" do
          subject { BancoBrasil.new(carteira: 16, codigo_cedente: 123456) }

          it { should have_valid(:numero_documento).when('1234', '12345', '12345', '12345678911234567') }
          it { should_not have_valid(:numero_documento).when(nil, '', '123456', '123456789112345678') }
        end

        context "when 'carteira' is 18 and 'codigo_cedente' 6 digits" do
          subject { BancoBrasil.new(carteira: 18, codigo_cedente: 123456) }

          it { should have_valid(:numero_documento).when('1234', '12345', '12345678911234567') }
          it { should_not have_valid(:numero_documento).when(nil, '', '123456', '1234567', '123456789112345678') }
        end

        context "when 'carteira' is 12 and 'codigo_cedente' 6 digits" do
          subject { BancoBrasil.new(carteira: 12, codigo_cedente: 123456) }

          it { should have_valid(:numero_documento).when('12345', '1234') }
          it { should_not have_valid(:numero_documento).when(nil, '', '123456', '12345678911234567') }
        end

        context "when 'codigo_cedente' 4 digits" do
          subject { BancoBrasil.new(codigo_cedente: 1234) }

          it { should have_valid(:numero_documento).when('123', '1235', '1234567') }
          it { should_not have_valid(:numero_documento).when(nil, '', '12345678', '12345678911234567') }
        end

        context "when 'codigo_cedente' 7 digits" do
          subject { BancoBrasil.new(codigo_cedente: 1234567) }

          it { should have_valid(:numero_documento).when('1234567890', '1235', '1234567') }
          it { should_not have_valid(:numero_documento).when(nil, '', '12345678901', '12345678911234567') }
        end

        context "when 'codigo_cedente' 8 digits" do
          subject { BancoBrasil.new(codigo_cedente: 12345678) }

          it { should have_valid(:numero_documento).when('123456789', '1235', '1234567') }
          it { should_not have_valid(:numero_documento).when(nil, '', '1234567890', '12345678911234567') }
        end

        context "when 'codigo_cedente' unsupported" do
          subject { BancoBrasil.new(codigo_cedente: 12345) }

          it { should have_valid(:numero_documento).when('123456789', '1235', '1234567', '1234567890', '12345678911234567') }
          it { should_not have_valid(:numero_documento).when(nil, '') }
        end
      end

      describe "#agencia" do
        context "when have a value" do
          subject { BancoBrasil.new(:agencia => '001') }

          it { expect(subject.agencia).to eq '0001' }
        end

        context "when is nil" do
          subject { BancoBrasil.new(:agencia => nil) }

          it { expect(subject.agencia).to be nil }
        end
      end

      describe "#conta_corrente" do
        context "when have a value" do
          subject { BancoBrasil.new(:conta_corrente => 913) }

          it { expect(subject.conta_corrente).to eq '00000913' }
        end

        context "when is nil" do
          subject { BancoBrasil.new(:conta_corrente => nil) }

          it { expect(subject.codigo_cedente).to be nil }
        end
      end

      describe "#numero_documento" do
        context "when have 'codigo_cedente' 4 digits" do
          subject { BancoBrasil.new(:numero_documento => 913, :codigo_cedente => 1234) }

          it { expect(subject.numero_documento).to eq '0000913' }
        end

        context "when have 'codigo_cedente' 6 digits" do
          subject { BancoBrasil.new(:numero_documento => 913, :codigo_cedente => 123456) }

          it { expect(subject.numero_documento).to eq '00913' }
        end

        context "when have 'codigo_cedente' 7 digits" do
          subject { BancoBrasil.new(:numero_documento => 913, :codigo_cedente => 1234567) }

          it { expect(subject.numero_documento).to eq '0000000913' }
        end

        context "when have 'codigo_cedente' 8 digits" do
          subject { BancoBrasil.new(:numero_documento => 913, :codigo_cedente => 12345678) }

          it { expect(subject.numero_documento).to eq '000000913' }
        end

        context "when is nil" do
          subject { BancoBrasil.new(:numero_documento => nil) }

          it { expect(subject.numero_documento).to be nil }
        end

        context "when 'codigo_cedente' is nil" do
          subject { BancoBrasil.new(:numero_documento => '12') }

          it { expect(subject.numero_documento).to eq '12' }
        end
      end

      describe "#codigo_banco" do
        it { expect(subject.codigo_banco).to eq '001' }
      end

      describe "#digito_codigo_banco" do
        it { expect(subject.digito_codigo_banco).to eq '9' }
      end

      describe "#agencia_codigo_cedente" do
        subject { BancoBrasil.new(agencia: 9999, conta_corrente: 99999) }

        it { expect(subject.agencia_codigo_cedente).to eq '9999-6 / 00099999-7' }
      end

      describe "#nosso_numero" do
        context "when 'codigo_cedente 4 digits" do
          subject { BancoBrasil.new(codigo_cedente: 1234, numero_documento: 1984) }

          it { expect(subject.nosso_numero).to eq '12340001984-7' }
        end

        context "when 'codigo_cedente 6 digits" do
          subject { BancoBrasil.new(codigo_cedente: 123456, numero_documento: 1984) }

          it { expect(subject.nosso_numero).to eq '12345601984-2' }
        end

        context "when 'codigo_cedente 7 digits" do
          subject { BancoBrasil.new(codigo_cedente: 1234567, numero_documento: 1984) }

          it { expect(subject.nosso_numero).to eq '12345670000001984' }
        end

        context "when 'codigo_cedente 8 digits" do
          subject { BancoBrasil.new(codigo_cedente: 12345678, numero_documento: 1984) }

          it { expect(subject.nosso_numero).to eq '12345678000001984' }
        end
      end

      describe "#codigo_cedente_quatro_digitos?" do
        context "when is true" do
          subject { BancoBrasil.new(codigo_cedente: 1234) }

          it { expect(subject.codigo_cedente_quatro_digitos?).to be true }
        end

        context "when is false" do
          subject { BancoBrasil.new(codigo_cedente: 12345) }

          it { expect(subject.codigo_cedente_quatro_digitos?).to be false }
        end
      end

      describe "#codigo_cedente_seis_digitos?" do
        context "when is true" do
          subject { BancoBrasil.new(codigo_cedente: 123456) }

          it { expect(subject.codigo_cedente_seis_digitos?).to be true }
        end

        context "when is false" do
          subject { BancoBrasil.new(codigo_cedente: 1234567) }

          it { expect(subject.codigo_cedente_seis_digitos?).to be false }
        end
      end

      describe "#codigo_cedente_sete_digitos?" do
        context "when is true" do
          subject { BancoBrasil.new(codigo_cedente: 1234567) }

          it { expect(subject.codigo_cedente_sete_digitos?).to be true }
        end

        context "when is false" do
          subject { BancoBrasil.new(codigo_cedente: 12345678) }

          it { expect(subject.codigo_cedente_sete_digitos?).to be false }
        end
      end

      describe "#codigo_cedente_oito_digitos?" do
        context "when is true" do
          subject { BancoBrasil.new(codigo_cedente: 12345678) }

          it { expect(subject.codigo_cedente_oito_digitos?).to be true }
        end

        context "when is false" do
          subject { BancoBrasil.new(codigo_cedente: 123456789) }

          it { expect(subject.codigo_cedente_oito_digitos?).to be false }
        end
      end

      describe "#nosso_numero_dezessete_posicoes?" do
        context "when 'carteira' 18, 'numero_documento' 17 digits and 'codigo_cedente' 6 digits" do
          subject { BancoBrasil.new(numero_documento: 12345678911234567, carteira: 18, codigo_cedente: 123456) }

          it { expect(subject.nosso_numero_dezessete_posicoes?).to be true }
        end

        context "when 'carteira' 16, 'numero_documento' 17 digits and 'codigo_cedente' 6 digits" do
          subject { BancoBrasil.new(numero_documento: 12345678911234567, carteira: 16, codigo_cedente: 123456) }

          it { expect(subject.nosso_numero_dezessete_posicoes?).to be true }
        end

        context "when is 'carteira' is not supported" do
          subject { BancoBrasil.new(numero_documento: 123456789, carteira: 12, codigo_cedente: 123456) }

          it { expect(subject.nosso_numero_dezessete_posicoes?).to be false }
        end

        context "when is 'codigo_cedente' is not supported" do
          subject { BancoBrasil.new(numero_documento: 123456789, carteira: 16, codigo_cedente: 1234567) }

          it { expect(subject.nosso_numero_dezessete_posicoes?).to be false }
        end
      end

      describe "#codigo_de_barras" do
        context "'codigo_cedente' with 4 digits" do
          subject do
            BancoBrasil.new do |banco_brasil|
              banco_brasil.carteira              = 18
              banco_brasil.valor_documento       = 2952.95
              banco_brasil.numero_documento      = 90801
              banco_brasil.agencia               = 7123
              banco_brasil.conta_corrente        = 19345
              banco_brasil.data_vencimento       = Date.parse('2012-12-28')
              banco_brasil.codigo_cedente        = 4321
            end
          end

          it { expect(subject.codigo_de_barras).to eq '00193556100002952954321009080171230001934518' }
          it { expect(subject.linha_digitavel).to eq '00194.32103 09080.171235 00019.345180 3 55610000295295' }
        end

        context "'codigo_cedente' with 6 digits" do
          subject do
            BancoBrasil.new do |banco_brasil|
              banco_brasil.carteira              = 18
              banco_brasil.valor_documento       = 14001.99
              banco_brasil.numero_documento      = 12901
              banco_brasil.agencia               = 5030
              banco_brasil.conta_corrente        = 14204195
              banco_brasil.data_vencimento       = Date.parse('2012-12-28')
              banco_brasil.codigo_cedente        = 555444
            end
          end

          it { expect(subject.codigo_de_barras).to eq '00197556100014001995554441290150301420419518' }
          it { expect(subject.linha_digitavel).to eq '00195.55440 41290.150303 14204.195185 7 55610001400199' }
        end

        context "'codigo_cedente' with 6 digits and 'nosso numero' with 17 digits" do
          subject do
            BancoBrasil.new do |banco_brasil|
              banco_brasil.carteira              = 12
              banco_brasil.valor_documento       = 14001.99
              banco_brasil.numero_documento      = 12345678911234567
              banco_brasil.agencia               = 5030
              banco_brasil.conta_corrente        = 14204195
              banco_brasil.data_vencimento       = Date.parse('2012-12-28')
              banco_brasil.codigo_cedente        = 555444
            end
          end

          it { expect(subject.linha_digitavel).to eq '' }
        end

        context "'codigo_cedente' with 6 digits and 'nosso numero' with 17 digits" do
          subject do
            BancoBrasil.new do |banco_brasil|
              banco_brasil.carteira              = 18
              banco_brasil.valor_documento       = 14001.99
              banco_brasil.numero_documento      = 12345678911234567
              banco_brasil.agencia               = 5030
              banco_brasil.conta_corrente        = 14204195
              banco_brasil.data_vencimento       = Date.parse('2012-12-28')
              banco_brasil.codigo_cedente        = 555444
            end
          end

          it { expect(subject.codigo_de_barras).to eq '00194556100014001995554441234567891123456721' }
          it { expect(subject.linha_digitavel).to eq '00195.55440 41234.567893 11234.567219 4 55610001400199' }
        end

        context "'codigo_cedente' with 7 digits" do
          subject do
            BancoBrasil.new do |banco_brasil|
              banco_brasil.carteira              = 18
              banco_brasil.valor_documento       = 2952.95
              banco_brasil.numero_documento      = 87654
              banco_brasil.agencia               = 9999
              banco_brasil.conta_corrente        = 99999
              banco_brasil.data_vencimento       = Date.parse('2012-12-28')
              banco_brasil.codigo_cedente        = 7777777
            end
          end

          it { expect(subject.codigo_de_barras).to eq '00197556100002952950000007777777000008765418' }
          it { expect(subject.linha_digitavel).to eq '00190.00009 07777.777009 00087.654182 7 55610000295295' }
        end

        context "'codigo_cedente' with 8 digits" do
          subject do
            BancoBrasil.new do |banco_brasil|
              banco_brasil.carteira              = 18
              banco_brasil.valor_documento       = 2952.95
              banco_brasil.numero_documento      = 87654
              banco_brasil.agencia               = 9999
              banco_brasil.conta_corrente        = 99999
              banco_brasil.data_vencimento       = Date.parse('2012-12-28')
              banco_brasil.codigo_cedente        = 77777778
            end
          end

          it { expect(subject.codigo_de_barras).to eq '00191556100002952950000007777777800008765418' }
          it { expect(subject.linha_digitavel).to eq '00190.00009 07777.777801 00087.654182 1 55610000295295' }
        end
      end
    end
  end
end
