$(function() {
    user = $('#user');
    if(user.length > 0) {
        App.messages = App.cable.subscriptions.create({ channel: 'UsersChannel', user_id: user.data('owner') }, {
            received: function(data) {
                if(data.size == 1) {
                    $('#checks table tbody').html('');
                    $('#checks table tbody').append(this.renderMessage(data));
                }
                else {
                    if(data.order == 0) $('#checks table tbody tr:nth-of-type(1)').before(this.renderMessage(data));
                    else $('#checks table tbody tr:nth-of-type(' + data.order + ')').after(this.renderMessage(data));
                }
            },

            renderMessage: function(data) {
                return '<tr><td>' + data.check.success + '/30</td><td>' + data.check.dust + '</td><td>' + data.deck.name + '</td><td>' + data.player + '</td><td>' + data.deck.formats + '</td><td>' + data.deck.author + '</td><td>' + data.username + '</td><td><a class="button small" data-turbolinks="false" href="/checks/' + data.check.id + '">' + data.button_1 + '</a><a class="button small" data-turbolinks="false" href="/decks/' + data.deck.id + '">' + data.button_2 + '</a></td></tr>';
            }
        });
    }
});
