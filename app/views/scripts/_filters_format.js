$('select#deck_formats').on('change', function() {
    $('#card_amount').html('0');
    mana_curve_reset();
    
    $('#new-tabs-content .tabs-panel label').removeClass('single').removeClass('double').removeClass('none').addClass('none');
    $('#new-tabs-content .tabs-panel input').val(0);
    
    if(this.value == 'standard') $('.costs .wild').hide();
    else $('.costs .wild').show();

    $('#cards_list .card').remove();
});