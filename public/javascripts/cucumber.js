foo = [];

jQuery(document).ready(function() {
  // add parser through the tablesorter addParser method
  jQuery.tablesorter.addParser({
    // set a unique id
    id: 'cucumber-ticket-references',
    is: function(s) {
      // return false so this parser is not auto detected
      return false;
    },
    format: function(s) {
      // text inside anchor
      var start_of_last_ticket_number_index = s.indexOf('>', s.lastIndexOf('<a')) + 1
      var end_of_last_ticket_number_index = s.indexOf('<', start_of_last_ticket_number_index)
      return s.substring(start_of_last_ticket_number_index, end_of_last_ticket_number_index)
    },
    // set type, either numeric or text
    type: 'numeric'
  });

  jQuery.tablesorter.addParser({
    // set a unique id
    id: 'cucumber-descriptions',
    is: function(s) {
      // return false so this parser is not auto detected
      return false;
    },
    format: function(s) {
      // text inside anchor
      return jQuery(s).text().toLowerCase();
    },
    // set type, either numeric or text
    type: 'text'
  });

  jQuery.tablesorter.addParser({
    // set a unique id
    id: 'cucumber-progress',
    is: function(s) {
      // return false so this parser is not auto detected
      return false;
    },
    format: function(s) {
      // width of covered cell
      return jQuery(s).find("td.covered").attr('width');
    },
    // set type, either numeric or text
    type: 'numeric'
  });

  jQuery('table.sorted').tablesorter({
    sortList: [[0,0]],
    headers: {
      0: {
        sorter:'cucumber-ticket-references'
      },
      1: {
        sorter:'cucumber-descriptions'
      },
      10: {
        sorter:'cucumber-progress'
      }
    }
  });

});
