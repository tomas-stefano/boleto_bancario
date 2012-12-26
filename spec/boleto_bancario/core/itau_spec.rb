require 'spec_helper'

module BoletoBancario
  module Core
    describe Itau do
      it_should_behave_like 'boleto bancario'

      describe "on validations" do
        describe "#carteira" do
          it { should have_valid(:carteira).when('109', '107', '175', 109, 198) }
          it { should_not have_valid(:carteira).when('10912', '10790', '17523', '1451') }
        end

        describe "#numero_documento" do
          it { should have_valid(:numero_documento).when('12345', '123456', '12345678') }
          it { should_not have_valid(:numero_documento).when('123456789', nil, '', '12345678910') }
        end

        describe "#conta_corrente" do
          it { should have_valid(:conta_corrente).when('1', '1234', '12345') }
          it { should_not have_valid(:conta_corrente).when('123456', nil, '1234567', '') }
        end

        describe "#agencia" do
          it { should have_valid(:agencia).when('1', '1234', '1234') }
          it { should_not have_valid(:agencia).when('12345', nil, '123456', '') }
        end

        describe "#codigo_cedente" do
          %w(107 122 142 143 196 198).each do |carteira_especial|
            context "when 'carteira' is special: #{carteira_especial}" do
              subject { Itau.new(carteira: carteira_especial) }

              it { should have_valid(:codigo_cedente).when('1', '1234', '12345') }
              it { should_not have_valid(:codigo_cedente).when('123456', nil, '1234567', '') }
            end
          end

          %w(109 126 131 146 150 168 174 175).each do |carteira|
            context "when 'carteira' isn't special: #{carteira}" do
              subject { Itau.new(carteira: carteira) }

              # Código do Cedente não precisa ser validado quando possui essas carteiras.
              #
              it { should have_valid(:codigo_cedente).when('1', '1234', '12345', nil, '') }
            end
          end

          describe "#seu_numero" do
            %w(107 122 142 143 196 198).each do |carteira_especial|
              context "when 'carteira' is special: #{carteira_especial}" do
                subject { Itau.new(carteira: carteira_especial) }

                it { should have_valid(:seu_numero).when('1', '1234', '1234567') }
                it { should_not have_valid(:seu_numero).when('12345678', nil, '123456789', '') }
              end
            end

            %w(109 126 131 146 150 168 174 175).each do |carteira|
              context "when 'carteira' isn't special: #{carteira}" do
                subject { Itau.new(carteira: carteira) }

                # Seu número não precisa ser validado quando possui essas carteiras.
                #
                it { should have_valid(:seu_numero).when('1', '1234', '12345', nil, '') }
              end
            end
          end
        end

        describe "#digito_conta_corrente" do
          it { should have_valid(:digito_conta_corrente).when('1', '2', '3') }
          it { should_not have_valid(:digito_conta_corrente).when('12', nil, '123', '') }
        end
      end

      describe "#numero_documento" do
        subject { Itau.new(:numero_documento => '123') }

        its(:numero_documento) { should eq '00000123' }
      end

      describe "#seu_numero" do
        context "when have a value" do
          subject { Itau.new(:seu_numero => '11804') }

          its(:seu_numero) { should eq '0011804' }
        end

        context "when is nil" do
          subject { Itau.new(:seu_numero => nil) }

          its(:seu_numero) { should be nil }
        end
      end

      describe "#agencia" do
        context "when have a value" do
          subject { Itau.new(:agencia => '001') }

          its(:agencia) { should eq '0001' }
        end

        context "when is nil" do
          subject { Itau.new(:agencia => nil) }

          its(:agencia) { should be nil }
        end
      end

      describe "#conta_corrente" do
        context "when have a value" do
          subject { Itau.new(:conta_corrente => 9013) }

          its(:conta_corrente) { should eq '09013' }
        end

        context "when is nil" do
          subject { Itau.new(:conta_corrente => nil) }

          its(:conta_corrente) { should be nil }
        end
      end

      describe "#codigo_cedente" do
        context "when have a value" do
          subject { Itau.new(:codigo_cedente => 1987) }

          its(:codigo_cedente) { should eq '01987' }
        end

        context "when is nil" do
          subject { Itau.new(:codigo_cedente => nil) }

          its(:codigo_cedente) { should be nil }
        end
      end

      describe "#codigo_banco" do
        its(:codigo_banco) { should eq '341' }
      end

      describe "#digito_codigo_banco" do
        its(:digito_codigo_banco) { should eq '7' }
      end

      describe "#agencia_codigo_cedente" do
        subject { Itau.new(:agencia => '0057', :conta_corrente => '12345', :digito_conta_corrente => '7') }

        it "should return the agency and bank account with digit" do
          subject.agencia_codigo_cedente.should eq '0057 / 12345-7'
        end
      end

      describe "#nosso_numero" do
        context "when 'carteira' is 126" do
          subject { Itau.new(:carteira => '126', :numero_documento => '12345') }

          it "should calculate the 'nosso numero' with carteira and document number" do
            subject.nosso_numero.should eq '126/00012345-8'
          end
        end

        context "when 'carteira' is 131" do
          subject { Itau.new(:carteira => '131', :numero_documento => '6789') }

          it "should calculate the 'nosso numero' with carteira and document number" do
            subject.nosso_numero.should eq '131/00006789-5'
          end
        end

        context "when 'carteira' is 146" do
          subject { Itau.new(:carteira => '146', :numero_documento => '147890') }

          it "should calculate the 'nosso numero' with carteira and document number" do
            subject.nosso_numero.should eq '146/00147890-9'
          end
        end

        context "when 'carteira' is 150" do
          subject { Itau.new(:carteira => '150', :numero_documento => '18765476') }

          it "should calculate the 'nosso numero' with carteira and document number" do
            subject.nosso_numero.should eq '150/18765476-2'
          end
        end

        context "when 'carteira' is 168" do
          subject { Itau.new(:carteira => '168', :numero_documento => '12784698') }

          it "should calculate the 'nosso numero' with carteira and document number" do
            subject.nosso_numero.should eq '168/12784698-3'
          end
        end

        context "when 'carteira' is 110" do
          subject do
            Itau.new(
              :agencia          => '0057',
              :conta_corrente   => '12345',
              :carteira         => '110',
              :numero_documento => '12345678'
            )
          end

          it "should format the 'nosso numero' with agencia, conta_corrente, carteira and document number" do
            subject.nosso_numero.should eq '110/12345678-8'
          end
        end

        context "when 'carteira' is 198" do
          subject do
            Itau.new(
              :agencia          => '0057',
              :conta_corrente   => '72192',
              :carteira         => '198',
              :numero_documento => '98712345'
            )
          end

          it "should follow the Itau documentation" do
            subject.nosso_numero.should eq '198/98712345-1'
          end
        end
      end

      describe "#carteira_especial?" do
        %w(107 122 142 143 196 198).each do |carteira_especial|
          context "when 'carteira' is special: #{carteira_especial}" do
            subject { Itau.new(carteira: carteira_especial) }

            its(:carteira_especial?) { should be true }
          end

          context "when 'carteira' is special: #{carteira_especial} as numeric" do
            subject { Itau.new(carteira: carteira_especial.to_i) }

            its(:carteira_especial?) { should be true }
          end
        end

        %w(109 126 131 146 150 168 174 175).each do |carteira|
          context "when 'carteira' isn't special: #{carteira}" do
            subject { Itau.new(carteira: carteira) }

            its(:carteira_especial?) { should be false }
          end
        end
      end

      describe "#codigo_de_barras_do_banco" do
        context "when default carteira" do
          subject do
            Itau.new do |boleto|
              boleto.carteira              = '109'
              boleto.numero_documento      = '12345678'
              boleto.agencia               = '0057'
              boleto.conta_corrente        = '12345'
              boleto.digito_conta_corrente = '7'
            end
          end

          its(:codigo_de_barras_do_banco) { should eq '1091234567800057123457000' }
        end

        context "when special 'carteira'" do
          subject do
            Itau.new(
              :codigo_cedente        => '94786',
              :carteira              => carteira,
              :numero_documento      => '12345678',
              :seu_numero            => '1108954'
            )
          end

          context "when 'carteira' is 107" do
            let(:carteira) { '107' }

            its(:codigo_de_barras_do_banco) { should eq '1071234567811089549478620' }
          end

          context "when 'carteira' is 122" do
            let(:carteira) { '122' }

            its(:codigo_de_barras_do_banco) { should eq '1221234567811089549478610' }
          end

          context "when 'carteira' is 142" do
            let(:carteira) { '142' }

            its(:codigo_de_barras_do_banco) { should eq '1421234567811089549478690' }
          end

          context "when 'carteira' is 143" do
            let(:carteira) { '143' }

            its(:codigo_de_barras_do_banco) { should eq '1431234567811089549478670' }
          end

          context "when 'carteira' is 196" do
            let(:carteira) { '196' }

            its(:codigo_de_barras_do_banco) { should eq '1961234567811089549478650' }
          end

          context "when 'carteira' is 198" do
            let(:carteira) { '198' }

            its(:codigo_de_barras_do_banco) { should eq '1981234567811089549478610' }
          end
        end
      end

      describe "#linha_digitavel" do
        subject do
          Itau.new do |boleto|
            boleto.carteira              = '175'
            boleto.agencia               = 1565
            boleto.conta_corrente        = 13877
            boleto.digito_conta_corrente = 1
            boleto.numero_documento      = 12345678
            boleto.data_vencimento       = Date.parse('2012-12-21')
            boleto.valor_documento       = 2952.95
          end
        end

        # Grep this example from boleto php demo page.
        its(:linha_digitavel) { should eq '34191.75124 34567.861561 51387.710000 1 55540000295295' }
      end

      describe "#to_partial_path" do
        its(:to_partial_path) { should eq 'boleto_bancario/itau' }
      end
    end
  end
end