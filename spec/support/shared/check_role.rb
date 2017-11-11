shared_examples_for 'Check role' do
    context 'authorized with user role' do
        it 'should render 404 if user has user role' do
            do_request_for_role

            expect(response).to render_template 'layouts/404'
        end
    end
end
