# frozen_string_literal: true

require 'spec_helper'

module BoletoBancario
  module Calculos
    describe Modulo11FatorDe2a7 do
      context 'with Bradesco documentation example' do
        subject { Modulo11FatorDe2a7.new('1900000000002') }

        it { is_expected.to eq '8' }
      end

      context 'with Bradesco example that returns P' do
        subject { Modulo11FatorDe2a7.new('1900000000001') }

        it { is_expected.to eq 'P' }
      end

      context 'with Bradesco example that returns zero' do
        subject { Modulo11FatorDe2a7.new('1900000000006') }

        it { is_expected.to eq '0' }
      end

      context "when have two digits" do
        subject { Modulo11FatorDe2a7.new('20') }

        it { is_expected.to eq '5' }
      end

      context "when have two digits (more examples)" do
        subject { Modulo11FatorDe2a7.new('26') }

        it { is_expected.to eq '4' }
      end

      context "more examples" do
        subject { Modulo11FatorDe2a7.new('64') }

        it { is_expected.to eq '7' }
      end
    end
  end
end
