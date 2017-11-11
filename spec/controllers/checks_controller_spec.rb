RSpec.describe ChecksController, type: :controller do
    describe 'GET #index' do
        it_behaves_like 'Check access'

        context 'When user logged in' do
            sign_in_user
            let!(:checks) { create_list(:check, 2, user: @current_user) }
            before { get :index }

            it 'collects an array of checks in @checks' do
                expect(assigns(:checks)).to match_array(checks)
            end

            it 'and collects an array of Heroes Names in @players' do
                expect(assigns(:player_classes)).to match_array([Player.first.name_en, Player.last.name_en])
            end

            it 'and collects an array of deck styles in @styles' do
                expect(assigns(:styles)).to match_array([Style.first.name_en, Style.last.name_en])
            end

            it 'and renders account page' do
                expect(response).to render_template :index
            end
        end

        def do_request
            get :index
        end
    end

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
                let!(:pos) { create :position_for_subs, positionable: check.deck }
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

                it 'and assigns the decks positions to @positions' do
                    expect(assigns(:positions)).to eq [[pos.card_id, pos.amount]]
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
                expect_any_instance_of(Subs::SearchService).to receive(:call)

                post :create, params: { success: '', dust: '', playerClass: '', formats: 'standard', power: '', style: '' }
            end

            it 'and should render head ok' do
                post :create, params: { success: '', dust: '', playerClass: '', formats: 'standard', power: '', style: '' }

                expect(response).to redirect_to checks_path
            end
        end

        def do_request
            post :create, params: { success: '', dust: '', playerClass: '', formats: 'standard', power: '', style: '' }
        end
    end
end
