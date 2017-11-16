$('#free_existed').on('click', function(e) {
    e.preventDefault();
    $('.card.Free input').val(2).prop('checked', true);
    $('.card.Free label').removeClass('none').removeClass('single').removeClass('double').addClass('double');
});

$('.class_existed').on('click', function(e) {
    e.preventDefault();
    name = $(this).attr('class').split(' ').pop();
    $('.' + name + ' input').val(2).prop('checked', true);
    $('.' + name + ' label').removeClass('none').removeClass('single').removeClass('double').addClass('double');
    $('.' + name + ' .Legendary input').val(1).prop('checked', true);
    $('.' + name + ' .Legendary label').removeClass('none').removeClass('single').removeClass('double').addClass('single');
});

$('.class_unexisted').on('click', function(e) {
    e.preventDefault();
    name = $(this).attr('class').split(' ').pop();
    $('.' + name + ' input').val(0);
    $('.' + name + ' label').removeClass('none').removeClass('single').removeClass('double').addClass('none');
});