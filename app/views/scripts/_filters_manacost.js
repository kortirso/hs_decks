$('#mana_cost').on('change', function() {
    mana = this.value;
    if(mana == '') $('.costs').show();
    else {
        $('.costs').hide();
        $('.cost_' + mana).show();
    }
});