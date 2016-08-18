require 'spec_helper'


describe BoletoBancario::Renderers::HTMLRenderer do

  describe ".render" do
    let(:boleto) { BoletoBancario::Core::Santander.new }

    context "with no boleto passed" do
      it "returns error message 'Nenhum boleto foi passado'" do
        expect( subject.render ).to eql 'Nenhum boleto foi passado'
      end
    end
  end

end
