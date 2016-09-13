RSpec.describe ChecksController, type: :controller do
    describe 'GET #show' do
        it_behaves_like 'Check access'

        context 'When user logged in' do
            sign_in_user

            context 'if check does not exist' do
                it 'should render 404' do
                    get :show, params: { id: 1 }

                    expect(response).to render_template 'layouts/404'
                end
            end

            context 'if check does not belong to user' do
                let!(:check) { create :check }

                it 'should render 404' do
                    get :show, params: { id: check.id }

                    expect(response).to render_template 'layouts/404'
                end
            end

            context 'for correct data' do
                let!(:check) { create :check, user: @current_user }
                let!(:sub) { create :substitution, check: check }
                let!(:lines) { create :position_for_check, positionable: check }
                let!(:subs) { create :position_for_subs, positionable: sub }
                before { get :show, params: { id: check.id } }

                it 'assigns the requested check to @check' do
                    expect(assigns(:check)).to eq check
                end

                it 'and assigns the checks deck to @deck' do
                    expect(assigns(:deck)).to eq check.deck
                end

                it 'and assigns the checks positions to @lines' do
                    expect(assigns(:lines)).to eq [[lines.card_id, lines.amount, lines.caption]]
                end

                it 'and assigns the substitution positions to @subs' do
                    expect(assigns(:subs)).to eq [[subs.card_id, subs.amount]]
                end

                it 'and renders decks page' do
                    expect(response).to render_template :show
                end
            end
        end

        def do_request
            get :show, params: { id: 1 }
        end
    end

    describe 'POST #create' do
        it_behaves_like 'Check access'

        context 'When user logged in' do
            sign_in_user

            it 'should call build Check method' do
                expect(Check).to receive(:build)

                post :create, params: { success: '', playerClass: '', formats: 'standard' }
            end

            it 'and should render head ok' do
                post :create, params: { success: '', playerClass: '', formats: 'standard' }

                expect(response.status).to eq 200
            end
        end

        def do_request
            post :create, params: { success: '', playerClass: '', formats: 'standard' }
        end
    end
end
