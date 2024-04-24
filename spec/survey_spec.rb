require 'pstore'
require_relative '../survey' # Make sure this points to your survey.rb file
require 'rspec'

describe 'PStore-based Questionnaire' do
  let(:store) { PStore.new('test.pstore') }
  let(:answers) { { "q1" => "yes", "q2" => "no", "q3" => "y", "q4" => "n", "q5" => "yes" } }

  before do
    store.transaction do
      store[:ratings] = []
      store[:answers] = {}
    end
  end

  describe '#do_prompt' do
    it 'stores answers in the PStore' do
      allow_any_instance_of(Kernel).to receive(:gets).and_return('yes', 'no', 'y', 'n', 'yes')
      expect(do_prompt(store)).to eq(answers)
    end
  end

  describe '#validate_answer' do
    it 'accepts valid answers' do
      %w[yes no y n].each do |answer|
        expect(validate_answer(answer)).to eq(answer)
      end
    end
  end

  describe '#calculate_ratings' do
    it 'calculates the correct ratings' do
      expect(calculate_ratings(answers)).to eq(60) # 3 out of 5 answers are 'yes' or 'y'
    end
  end

  describe '#calculate_average_rating' do
    it 'calculates the correct average rating' do
      store.transaction do
        store[:ratings] = [50, 70, 80]
      end
      expect(calculate_average_rating(store)).to eq(66) # Average of 50, 70, and 80
    end
  end

  describe '#do_report' do
    it 'outputs the correct ratings' do
      expect { do_report(store, answers) }.to output(/Rating for this run: 60%/).to_stdout
      expect { do_report(store, answers) }.to output(/Average rating for all runs: \d+%$/).to_stdout
    end
  end
end
