shared_examples_for 'boleto bancario' do
  describe "on validations" do
    before do
      subject.should respond_to(:cedente, :endereco_cedente, :valor_documento, :numero_documento)
      subject.should respond_to(:carteira, :sacado, :documento_sacado, :data_vencimento)
    end

    it { should have_valid(:cedente).when('Razao Social') }
    it { should_not have_valid(:cedente).when(nil, '') }

    it { should have_valid(:endereco_cedente).when('Rua Itapaiuna') }
    it { should_not have_valid(:endereco_cedente).when(nil, '') }

    it { should have_valid(:valor_documento).when(1, 1.99, 100.99, 99_999_999.99, '100.99') }
    it { should_not have_valid(:valor_documento).when(nil, '', '100,99', 100_000_000.99) }

    it { should have_valid(:numero_documento).when('09890') }
    it { should_not have_valid(:numero_documento).when(nil, '') }

    it { should have_valid(:carteira).when('10', '75') }
    it { should_not have_valid(:carteira).when(nil, '') }

    it { should have_valid(:sacado).when('Teste', 'Outro Teste') }
    it { should_not have_valid(:sacado).when(nil, '') }

    it { should have_valid(:documento_sacado).when('112.167.084-95', '613.318.746-88') }
    it { should_not have_valid(:documento_sacado).when(nil, '') }

    it { should have_valid(:data_vencimento).when(Date.today) }
    it { should_not have_valid(:data_vencimento).when('', nil, '01/10/2012', '2012-10-2012') }
  end

  describe "#to_partial_path" do
    it { should respond_to(:to_partial_path) }
  end

  describe "#persisted?" do
    before { subject.should respond_to(:persisted?) }

    its(:persisted?) { should be false }
  end

  describe "#carteira_formatada" do
    it { subject.should respond_to(:carteira_formatada) }
  end

  describe "#valor_documento_formatado" do
    it { subject.should respond_to(:valor_formatado_para_codigo_de_barras) }
  end

  describe "#aceite_formatado" do
    it { subject.should respond_to(:aceite_formatado) }
  end

  describe "#codigo_do_banco" do
    before { subject.should respond_to(:codigo_banco) }

    it { expect { subject.codigo_banco }.to_not raise_error() }
  end

  describe "#digito_do_codigo_do_banco" do
    before { subject.should respond_to(:digito_codigo_banco) }

    it { expect { subject.digito_codigo_banco }.to_not raise_error() }
  end

  describe "#codigo_banco_formatado" do
    before { subject.should respond_to(:codigo_banco_formatado) }

    it "should format the 'codigo_banco' with digit" do
      subject.stub(:codigo_banco).and_return('001')
      subject.stub(:digito_codigo_banco).and_return('9')
      subject.codigo_banco_formatado.should eq '001-9'
    end
  end

  describe "#agencia_codigo_cedente" do
    before { subject.should respond_to(:agencia_codigo_cedente) }

    it { expect { subject.agencia_codigo_cedente }.to_not raise_error() }
  end

  describe "#nosso_numero" do
    before { subject.should respond_to(:nosso_numero) }

    it { expect { subject.nosso_numero }.to_not raise_error() }
  end

  describe "#carteira_formatada" do
    it { should respond_to(:carteira, :carteira_formatada) }
  end

  describe "#codigo_de_barras_do_banco" do
    before { subject.should respond_to(:codigo_de_barras_do_banco) }

    it { expect { subject.codigo_de_barras_do_banco }.to_not raise_error() }
  end

  describe "#valor_formatado_para_codigo_de_barras" do
    it { subject.should respond_to(:valor_documento) }

    it { subject.should respond_to(:valor_formatado_para_codigo_de_barras) }
  end

  describe "#codigo_de_barras" do
    before { subject.should respond_to(:codigo_de_barras) }

    it "should return the barcode with DAC (barcode digit)" do
      subject.stub(:codigo_de_barras_padrao).and_return('341916670000012345')
      subject.stub(:codigo_de_barras_do_banco).and_return('1101234567880057123457000')
      subject.codigo_de_barras.should eq '34196166700000123451101234567880057123457000'
    end
  end

  describe "#codigo_de_barras_padrao" do
    before { subject.should respond_to(:codigo_de_barras_padrao, :valor_documento) }

    context "barcode positions" do
      let(:boleto) { described_class.new(:valor_documento => 190.99, :data_vencimento => Date.parse('2012-10-20')) }

      it "should return the first 18 positions of barcode" do
        boleto.stub(:codigo_banco).and_return('341')
        boleto.codigo_de_barras_padrao.should eq '341954920000019099'
      end
    end
  end

  describe "#digito_codigo_de_barras" do
    before { subject.should respond_to(:digito_codigo_de_barras) }

    context "using the Itau docs example" do
      it "should calculate the digit using the modulo 11 factors 2 until 9" do
        subject.stub(:codigo_de_barras_padrao).and_return('341916670000012345')
        subject.stub(:codigo_de_barras_do_banco).and_return('1101234567880057123457000')
        subject.digito_codigo_de_barras.should eq '6'
      end
    end
  end

  describe "#linha_digitavel" do
    before { subject.should respond_to(:linha_digitavel) }

    it "should return the digital line" do
      subject.stub(:codigo_de_barras).and_return('39998100100000311551111122222500546666666001')
      subject.linha_digitavel.should eq '39991.11119 22222.500542 66666.660015 8 10010000031155'
    end
  end

  describe "#fator_de_vencimento" do
    before { subject.should respond_to(:fator_de_vencimento) }

    it "should calculate the expiration factor" do
      subject.data_vencimento = Date.parse('2002-05-11')
      subject.fator_de_vencimento.should eq '1677'
    end
  end
end
