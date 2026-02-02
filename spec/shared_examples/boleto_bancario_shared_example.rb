# frozen_string_literal: true

RSpec.shared_examples 'boleto bancario' do
  describe 'on validations' do
    it 'responds to required attributes' do
      expect(subject).to respond_to(:cedente, :endereco_cedente, :valor_documento, :numero_documento)
      expect(subject).to respond_to(:carteira, :sacado, :documento_sacado, :data_vencimento)
    end

    it { is_expected.to have_valid(:cedente).when('Razao Social') }
    it { is_expected.not_to have_valid(:cedente).when(nil, '') }

    it { is_expected.to have_valid(:endereco_cedente).when('Rua Itapaiuna') }
    it { is_expected.not_to have_valid(:endereco_cedente).when(nil, '') }

    it { is_expected.to have_valid(:numero_documento).when('09890') }
    it { is_expected.not_to have_valid(:numero_documento).when(nil, '') }

    it { is_expected.to have_valid(:sacado).when('Teste', 'Outro Teste') }
    it { is_expected.not_to have_valid(:sacado).when(nil, '') }

    it { is_expected.to have_valid(:documento_sacado).when('112.167.084-95', '613.318.746-88') }
    it { is_expected.not_to have_valid(:documento_sacado).when(nil, '') }

    it { is_expected.to have_valid(:data_vencimento).when(Date.today) }
    it { is_expected.not_to have_valid(:data_vencimento).when('', nil, '01/10/2012', '2012-10-2012') }
  end

  describe '#to_partial_path' do
    it { is_expected.to respond_to(:to_partial_path) }
  end

  describe '#persisted?' do
    it { expect(subject).to respond_to(:persisted?) }
    it { expect(subject.persisted?).to be false }
  end

  describe '#carteira_formatada' do
    it { expect(subject).to respond_to(:carteira_formatada) }
  end

  describe '#valor_documento_formatado' do
    it { expect(subject).to respond_to(:valor_formatado_para_codigo_de_barras) }
  end

  describe '#aceite_formatado' do
    it { expect(subject).to respond_to(:aceite_formatado) }
  end

  describe '#codigo_do_banco' do
    it { expect(subject).to respond_to(:codigo_banco) }
    it { expect { subject.codigo_banco }.not_to raise_error }
  end

  describe '#digito_do_codigo_do_banco' do
    it { expect(subject).to respond_to(:digito_codigo_banco) }
    it { expect { subject.digito_codigo_banco }.not_to raise_error }
  end

  describe '#codigo_banco_formatado' do
    it { expect(subject).to respond_to(:codigo_banco_formatado) }

    it "formats the 'codigo_banco' with digit" do
      allow(subject).to receive(:codigo_banco).and_return('001')
      allow(subject).to receive(:digito_codigo_banco).and_return('9')
      expect(subject.codigo_banco_formatado).to eq '001-9'
    end
  end

  describe '#agencia_codigo_cedente' do
    it { expect(subject).to respond_to(:agencia_codigo_cedente) }
    it { expect { subject.agencia_codigo_cedente }.not_to raise_error }
  end

  describe '#nosso_numero' do
    it { expect(subject).to respond_to(:nosso_numero) }
    it { expect { subject.nosso_numero }.not_to raise_error }
  end

  describe '#carteira_formatada' do
    it { is_expected.to respond_to(:carteira, :carteira_formatada) }
  end

  describe '#codigo_de_barras_do_banco' do
    it { expect(subject).to respond_to(:codigo_de_barras_do_banco) }
    it { expect { subject.codigo_de_barras_do_banco }.not_to raise_error }
  end

  describe '#valor_formatado_para_codigo_de_barras' do
    it { expect(subject).to respond_to(:valor_documento) }
    it { expect(subject).to respond_to(:valor_formatado_para_codigo_de_barras) }
  end

  describe '#codigo_de_barras' do
    it { expect(subject).to respond_to(:codigo_de_barras) }

    it 'returns the barcode with DAC (barcode digit)' do
      allow(subject).to receive(:codigo_de_barras_padrao).and_return('341916670000012345')
      allow(subject).to receive(:codigo_de_barras_do_banco).and_return('1101234567880057123457000')
      expect(subject.codigo_de_barras).to eq '34196166700000123451101234567880057123457000'
    end
  end

  describe '#codigo_de_barras_padrao' do
    it { expect(subject).to respond_to(:codigo_de_barras_padrao, :valor_documento) }

    context 'barcode positions' do
      let(:boleto) { described_class.new(valor_documento: 190.99, data_vencimento: Date.parse('2012-10-20')) }

      it 'returns the first 18 positions of barcode' do
        allow(boleto).to receive(:codigo_banco).and_return('341')
        expect(boleto.codigo_de_barras_padrao).to eq '341954920000019099'
      end
    end
  end

  describe '#digito_codigo_de_barras' do
    it { expect(subject).to respond_to(:digito_codigo_de_barras) }

    context 'using the Itau docs example' do
      it 'calculates the digit using the modulo 11 factors 2 until 9' do
        allow(subject).to receive(:codigo_de_barras_padrao).and_return('341916670000012345')
        allow(subject).to receive(:codigo_de_barras_do_banco).and_return('1101234567880057123457000')
        expect(subject.digito_codigo_de_barras).to eq '6'
      end
    end
  end

  describe '#linha_digitavel' do
    it { expect(subject).to respond_to(:linha_digitavel) }

    it 'returns the digital line' do
      allow(subject).to receive(:codigo_de_barras).and_return('39998100100000311551111122222500546666666001')
      expect(subject.linha_digitavel).to eq '39991.11119 22222.500542 66666.660015 8 10010000031155'
    end
  end

  describe '#fator_de_vencimento' do
    it { expect(subject).to respond_to(:fator_de_vencimento) }

    it 'calculates the expiration factor' do
      subject.data_vencimento = Date.parse('2002-05-11')
      expect(subject.fator_de_vencimento).to eq '1677'
    end
  end
end
