$(function() {
    $('#cards_list').on('click', '.remove_card', function(e) {
        card_class = $(this).closest('.card').attr('class').split(' ').pop();
        object = $('.right_side').find('.' + card_class + ' label');

        amount = parseInt($('#card_amount').html());
        if ($(object).hasClass('double')) {
            $('#card_amount').html(amount - 2);
            $(object).mana_curve(-2);
            $(object).removeClass('double').addClass('none');
        }
        else if ($(object).hasClass('single')) {
            $('#card_amount').html(amount - 1);
            $(object).mana_curve(-1);
            $(object).removeClass('single').addClass('none');
        }

        $(object).closest('div').children('input').val(0);
        $('#cards_list .' + card_class.split(' ').pop()).remove();
    });

    $('#deck .cards .card label').click(function(e) {
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

    $('.duplicate_exchange').click(function(e) {
        var formsOnPage, newNestedForm;
        e.preventDefault();
        nestedExchange = $(this).closest('.exchanges').children('.pos').last();
        newNestedForm = $(nestedExchange).clone();
        formsOnPage = $(nestedExchange).data("position") + 1;
        $(newNestedForm).attr('data-position', formsOnPage);    
        $(newNestedForm).find('input').each(function() {
            var newId, newName, oldId, oldName;
            oldId = $(this).attr('id');
            newId = oldId.split('_').slice(0, -1).join('_') + '_' +formsOnPage;
            $(this).attr('id', newId);
            oldName = $(this).attr('name');
            newName = oldName.split('_')[0] + '_' + formsOnPage + ']';
            $(this).attr('name', newName);
            $(this).val('');
        });
        $(newNestedForm).insertAfter(nestedExchange);
    });

    $('#exchanges').on('click', '.remove_exchange', function(e) {
        e.preventDefault();
        if($(this).closest('.exchanges').children('.pos').length != 1) {
            $(this).closest('.pos').remove();
        }
    });

    $('.duplicate_line').click(function(e) {
        var formsOnPage, newNestedForm;
        e.preventDefault();
        nestedExchange = $(this).closest('.lines').children('.pos').last();
        newNestedForm = $(nestedExchange).clone();
        formsOnPage = $(nestedExchange).data('position') + 1;
        $(newNestedForm).attr('data-position', formsOnPage);    
        $(newNestedForm).find('input').each(function() {
            var newId, newName, oldId, oldName;
            oldId = $(this).attr('id');
            newId = oldId.split('_').slice(0, -1).join('_') + '_' +formsOnPage;
            $(this).attr('id', newId);
            oldName = $(this).attr('name');
            newName = oldName.split('_')[0] + '_' + formsOnPage + ']';
            $(this).attr('name', newName);
            $(this).val('');
        });
        $(newNestedForm).insertAfter(nestedExchange);
    });

    $('#lines').on('click', '.remove_line', function(e) {
        e.preventDefault();
        if($(this).closest('.lines').children('.pos').length != 1) {
            $(this).closest('.pos').remove();
        }
    });

    $('.duplicate_mulligan').click(function(e) {
        var formsOnPage, newNestedForm;
        e.preventDefault();
        nestedExchange = $(this).closest('.mulligans').children('.pos').last();
        newNestedForm = $(nestedExchange).clone();
        formsOnPage = $(nestedExchange).data("position") + 1;
        $(newNestedForm).attr('data-position', formsOnPage);    
        $(newNestedForm).find('select').each(function() {
            var newId, newName, oldId, oldName;
            oldId = $(this).attr('id');
            newId = oldId.split('_').slice(0, -1).join('_') + '_' +formsOnPage;
            $(this).attr('id', newId);
            oldName = $(this).attr('name');
            newName = oldName.split('_')[0] + '_' + formsOnPage + ']';
            $(this).attr('name', newName);
            $(this).val('');
        });
        $(newNestedForm).insertAfter(nestedExchange);
    });

    $('#lines').on('click', '.remove_mulligan', function(e) {
        e.preventDefault();
        if($(this).closest('.mulligans').children('.pos').length != 1) {
            $(this).closest('.pos').remove();
        }
    });
});