$('#cards_collection .costs label').click(function(e) {
    e.preventDefault();
    if($(this).hasClass('none')) {
        $(this).removeClass('none').addClass('single');
        $(this).closest('div').children('input').val(1).attr('checked', true);
    }
    else if($(this).hasClass('single')) {
        if($(this).closest('.card').hasClass('Legendary')) {
            $(this).removeClass('single').addClass('none');
            $(this).closest('div').children('input').val(0);
        }
        else {
            $(this).removeClass('single').addClass('double');
            $(this).closest('div').children('input').val(2);
        }
    }
    else {
        $(this).removeClass('double').addClass('none');
        $(this).closest('div').children('input').val(0);
    }
});