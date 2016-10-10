shared_examples_for 'Check access' do
    context 'unauthorized' do
        it 'render welcome page' do
            do_request

            expect(response).to render_template 'layouts/404'
        end
    end
end