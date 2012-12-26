require 'spec_helper'

module BoletoBancario
  module Calculos
    describe Modulo11FatorDe2a9RestoZero do
      describe "#calculate" do
        context "with a one number digit" do
          subject { Modulo11FatorDe2a9RestoZero.new(6) }

          it { should eq '0' }
        end

        context "with a two number digit" do
          subject { Modulo11FatorDe2a9RestoZero.new(100) }

          it { should eq '7' }
        end

        context "with a three number digit" do
          subject { Modulo11FatorDe2a9RestoZero.new(1004) }

          it { should eq '9' }
        end

        context "with a three number digit that returns zero" do
          subject { Modulo11FatorDe2a9RestoZero.new(1088) }

          it { should eq '0' }
        end

        context "when mod division return '10'" do
          subject { Modulo11FatorDe2a9RestoZero.new(1073) }

          it { should eq '1' }
        end
      end
    end
  end
end