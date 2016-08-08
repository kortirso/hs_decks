$(function() {
    $('#new-cards-tabs li:nth-of-type(n+2)').hide();
    $('#new-cards-tabs li.Common').show();

    $('#new-tabs-content .costs label').click(function(e) {
        e.preventDefault();
        amount = parseInt($('#card_amount').html());
        if($(this).hasClass('none')) {
            if(amount < 30) {
                $(this).removeClass('none').addClass('single');
                $(this).closest('p').children('input').val(1).attr('checked', true);
                $('#card_amount').html(amount + 1);
            }
        }
        else if($(this).hasClass('single')) {
            if(amount >= 30 || $(this).hasClass('legendary')) {
                $(this).removeClass('single').addClass('none');
                $(this).closest('p').children('input').val(0).attr('checked', false);
                $('#card_amount').html(amount - 1);
            }
            else {
                $(this).removeClass('single').addClass('double');
                $(this).closest('p').children('input').val(2);
                $('#card_amount').html(amount + 1);
            }
        }
        else {
            $(this).removeClass('double').addClass('none');
            $(this).closest('p').children('input').val(0).attr('checked', false);
            $('#card_amount').html(amount - 2);
        }
    });

    $('#tabs-content .costs label').click(function(e) {
        e.preventDefault();
        if($(this).hasClass('none')) {
            $(this).removeClass('none').addClass('single');
            $(this).closest('p').children('input').val(1).attr('checked', true);
        }
        else if($(this).hasClass('single')) {
            if($(this).hasClass('legendary')) {
                $(this).removeClass('single').addClass('none');
                $(this).closest('p').children('input').val(0).attr('checked', false);
            }
            else {
                $(this).removeClass('single').addClass('double');
                $(this).closest('p').children('input').val(2);
            }
        }
        else {
            $(this).removeClass('double').addClass('none');
            $(this).closest('p').children('input').val(0).attr('checked', false);
        }
    });

    $('select#playerClass').on('change', function() {
        $('#card_amount').html('0');

        $('#new-cards-tabs li.is-active a').attr('aria-selected', false);
        $('#new-cards-tabs li.is-active').removeClass('is-active');
        $('#new-cards-tabs li.visibled').hide();

        $('#new-cards-tabs li.' + this.value + ' a').attr('aria-selected', true);
        $('#new-cards-tabs li.' + this.value).show().addClass('is-active visibled');

        $('#new-tabs-content .is-active').attr('aria-hidden', true).removeClass('is-active');

        $('#new-tabs-content #' + $('#new-cards-tabs li.' + this.value + ' a').attr('aria-controls')).attr('aria-hidden', false).addClass('is-active');

        $('#new-tabs-content .tabs-panel label').removeClass('single').removeClass('double').removeClass('none').addClass('none');
        $('#new-tabs-content .tabs-panel input').val(0).prop('checked', false);
    });

    $('select#formats').on('change', function() {
        $('#card_amount').html('0');
        $('#new-tabs-content .tabs-panel label').removeClass('single').removeClass('double').removeClass('none').addClass('none');
        $('#new-tabs-content .tabs-panel input').val(0).prop('checked', false);
        
        if(this.value == 'standard') $('.costs p.wild').hide();
        else $('.costs p.wild').show();
    });
});