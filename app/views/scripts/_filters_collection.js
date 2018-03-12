$('#collection').on('change', function() {
    collection = this.value;
    console.log(collection);
    if(collection == '') $('.card').show();
    else {
        $('.card').hide();
        console.log(collection.split(' ').join('_').split("'").join(''))
        $('.card.' + collection.split(' ').join('_').split("'").join('')).show();
    }
});