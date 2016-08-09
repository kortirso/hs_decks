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
                    $('#checks table tbody tr:nth-of-type(' + data.order + ')').before(this.renderMessage(data));
                }
            },

            renderMessage: function(data) {
                return '<tr><td>' + data.check.success + '%</td><td>' + data.deck.name + '</td><td>' + data.deck.playerClass + '</td><td>' + data.deck.formats + '</td><td>' + data.username + '</td><td><a class="button small" data-turbolinks="false" href="/checks/' + data.check.id + '">View Check</a><a class="button small" data-turbolinks="false" href="/decks/' + data.deck.id + '">View Deck</a></td></tr>';
            }
        });
    }
});