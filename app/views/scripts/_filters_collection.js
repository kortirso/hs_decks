$('#collection').on('change', function() {
    collection = this.value;
    if(collection == '') $('.card').show();
    else {
        $('.card').hide();
        $('.card.' + collection.split(' ').join('_')).show();
    }
});