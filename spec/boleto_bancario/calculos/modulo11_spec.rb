require 'spec_helper'

module BoletoBancario
  module Calculos
    describe Modulo11 do
      subject { Modulo11.new(1) }

      describe "#fatores" do
        before { Modulo11.any_instance.stub(:calculate).and_return(1) }

        it { expect { subject.fatores }.to raise_error(NotImplementedError, "Not implemented #fatores in subclass.") }
      end

      describe "#calculate" do
        it { expect { Modulo11.new(1) }.to raise_error(NotImplementedError, "Not implemented #calculate in subclass.") }
      end
    end
  end
end