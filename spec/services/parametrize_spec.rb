describe Parametrize do
    context '.deck_getting_params' do

    end

    context '.check_getting_params' do
        let(:empty_params) { ActionController::Parameters.new({ success: '', dust: '', playerClass: '', formats: 'wild', something: '' }) }
        let(:params) { Parametrize.check_getting_params(empty_params) }

        it 'should returns hash with 4 params' do
            expect(params.kind_of? Hash).to eq true
            expect(params.size).to eq 4
        end

        it 'and all 4 params are not nil' do
            expect(params['success']).to_not eq nil
            expect(params['dust']).to_not eq nil
            expect(params['playerClass']).to_not eq nil
            expect(params['formats']).to_not eq nil
        end
    end
end