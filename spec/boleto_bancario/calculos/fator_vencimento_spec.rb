# frozen_string_literal: true

require 'spec_helper'

module BoletoBancario
  module Calculos
    describe FatorVencimento do
      describe '#base_date' do
        context 'for dates before FEBRABAN 2025 transition' do
          it 'uses the old base date 1997-10-07' do
            expect(FatorVencimento.new(Date.parse('2012-02-01')).base_date).to eq Date.new(1997, 10, 7)
          end

          it 'uses old base date on the last day before transition' do
            expect(FatorVencimento.new(Date.parse('2025-02-21')).base_date).to eq Date.new(1997, 10, 7)
          end
        end

        context 'for dates from FEBRABAN 2025 transition onwards' do
          it 'uses the new base date 2022-05-29' do
            expect(FatorVencimento.new(Date.parse('2025-02-22')).base_date).to eq Date.new(2022, 5, 29)
          end

          it 'uses new base date for future dates' do
            expect(FatorVencimento.new(Date.parse('2026-01-01')).base_date).to eq Date.new(2022, 5, 29)
          end
        end
      end

      describe '#calculate' do
        it 'returns an empty string when passing nil value' do
          expect(FatorVencimento.new(nil)).to eq ''
        end

        it 'returns an empty string when passing empty value' do
          expect(FatorVencimento.new('').to_s).to eq ''
        end

        context 'dates before FEBRABAN 2025 transition (using old base date)' do
          it 'calculates the days between expiration date and base date' do
            expect(FatorVencimento.new(Date.parse('2012-12-02'))).to eq '5535'
          end

          it 'calculates equal to Itau documentation example' do
            expect(FatorVencimento.new(Date.parse('2000-07-04'))).to eq '1001'
          end

          it 'calculates equal to Itau documentation last section of the docs' do
            expect(FatorVencimento.new(Date.parse('2002-05-01'))).to eq '1667'
          end

          it 'calculates the days between expiration date one year ago' do
            expect(FatorVencimento.new(Date.parse('2011-05-25'))).to eq '4978'
          end

          it 'calculates the days between expiration date two years ago' do
            expect(FatorVencimento.new(Date.parse('2010-10-02'))).to eq '4743'
          end

          it 'calculates the days between expiration date one year from now' do
            expect(FatorVencimento.new(Date.parse('2013-02-01'))).to eq '5596'
          end

          it 'calculates the days between expiration date eight years from now' do
            expect(FatorVencimento.new(Date.parse('2020-02-01'))).to eq '8152'
          end

          it 'calculates the days between expiration date formatting with 4 digits' do
            expect(FatorVencimento.new(Date.parse('1997-10-08'))).to eq '0001'
          end

          it 'calculates to the maximum date (9999) on the last day before transition' do
            expect(FatorVencimento.new(Date.parse('2025-02-21'))).to eq '9999'
          end
        end

        context 'dates from FEBRABAN 2025 transition onwards (using new base date)' do
          it 'returns 1000 on the transition date (2025-02-22)' do
            # 2025-02-22 is exactly 1000 days from 2022-05-29
            expect(FatorVencimento.new(Date.parse('2025-02-22'))).to eq '1000'
          end

          it 'returns 1001 on the day after transition (2025-02-23)' do
            expect(FatorVencimento.new(Date.parse('2025-02-23'))).to eq '1001'
          end

          it 'returns 1007 one week after transition (2025-03-01)' do
            expect(FatorVencimento.new(Date.parse('2025-03-01'))).to eq '1007'
          end

          it 'calculates correctly for dates in 2026' do
            # 2026-01-01 is 1313 days from 2022-05-29
            expect(FatorVencimento.new(Date.parse('2026-01-01'))).to eq '1313'
          end

          it 'calculates correctly for dates far in the future' do
            # 2030-01-01 is 2774 days from 2022-05-29
            expect(FatorVencimento.new(Date.parse('2030-01-01'))).to eq '2774'
          end
        end
      end

      describe 'constant values' do
        it 'has the correct old base date' do
          expect(FatorVencimento::OLD_BASE_DATE).to eq Date.new(1997, 10, 7)
        end

        it 'has the correct new base date' do
          expect(FatorVencimento::NEW_BASE_DATE).to eq Date.new(2022, 5, 29)
        end

        it 'has the correct transition date' do
          expect(FatorVencimento::TRANSITION_DATE).to eq Date.new(2025, 2, 22)
        end

        it 'has the correct new base factor' do
          expect(FatorVencimento::NEW_BASE_FACTOR).to eq 1000
        end
      end
    end
  end
end
