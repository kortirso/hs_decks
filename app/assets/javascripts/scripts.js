$(function() {
    $('.costs label').click(function(e) {
        if($(this).hasClass('none')) {
            $(this).removeClass('none');
            $(this).addClass('single');
            $(this).closest('p').children('input').val(1);
            $(this).closest('p').children('input').prop('checked', false);
        }
        else if($(this).hasClass('single')) {
            $(this).removeClass('single');
            $(this).addClass('double');
            $(this).closest('p').children('input').val(2);
            $(this).closest('p').children('input').prop('checked', false);
        }
        else {
            $(this).removeClass('double');
            $(this).addClass('none');
            $(this).closest('p').children('input').val(0);
            $(this).closest('p').children('input').prop('checked', true);
        }
    });
});