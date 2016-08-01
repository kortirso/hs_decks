$(function() {
    $('.costs label').click(function(e) {
        if($(this).hasClass('checked')) $(this).removeClass('checked');
        else $(this).addClass('checked');
    });
});