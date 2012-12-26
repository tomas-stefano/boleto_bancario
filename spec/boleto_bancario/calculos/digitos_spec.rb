require 'spec_helper'

module BoletoBancario
  module Calculos
    describe Digitos do
      (0..9).each do |number|
        it "should return self when is #{number}" do
          Digitos.new(number).sum.should eq number
        end
      end

      { 11 => 2, '18' => 9, 99 => 18, '58' => 13, 112 => 4, '235' => 10 }.each do |number, expecting|
        it "should sum the sum of the digits when is '#{number}', expecting to be '#{expecting}'" do
          Digitos.new(number).sum.should eq expecting
        end
      end
    end
  end
end