# frozen_string_literal: true

require 'spec_helper'

module BoletoBancario
  module Calculos
    describe Digitos do
      (0..9).each do |number|
        it "returns self when is #{number}" do
          expect(Digitos.new(number).sum).to eq number
        end
      end

      { 11 => 2, '18' => 9, 99 => 18, '58' => 13, 112 => 4, '235' => 10 }.each do |number, expecting|
        it "sums the sum of the digits when is '#{number}', expecting to be '#{expecting}'" do
          expect(Digitos.new(number).sum).to eq expecting
        end
      end
    end
  end
end
