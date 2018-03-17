$(function() {
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