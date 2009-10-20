var cucumberStepCompletion = {
  cachedSteps: null,
  stepTemplates: function() {
    if (!cucumberStepCompletion.cachedSteps) {
      cucumberStepCompletion.cachedSteps = [];
      if (cucumberStepCompletion.cucumberSteps) {
        for (step in cucumberStepCompletion.cucumberSteps) {
          cucumberStepCompletion.cachedSteps[cucumberStepCompletion.cachedSteps.length] = step;
        }
      }
    }
    return cucumberStepCompletion.cachedSteps
  },
  matchesForStepTemplate: function(template) {
    return cucumberStepCompletion.cucumberSteps[template];
  },
  stepTemplateToHtmlOption: function(elementOfArray, indexInArray) {
    return "<option value='" + elementOfArray + "'>" + elementOfArray + "</option>\n";
  },
  stepMatchToHtml: function(elementOfArray, indexInArray) {
    return "<li>" + elementOfArray + "</li>";
  },
  matchingStepsToHtml: function(cucumberStepIndex) {
    var stepDefinition = cucumberStepCompletion.cachedSteps[cucumberStepIndex];
    var matchingSteps = cucumberStepCompletion.cucumberSteps[stepDefinition];
    var matchingStepsItems = jQuery.map(matchingSteps, cucumberStepCompletion.stepMatchToHtml);
    var html = "<div class='matching-steps'><ul>";
    html += matchingStepsItems.join("\n");
    html += "</div></ul>";
    return html;
  },
  displayMatchingStepsFor: function(cucumberStep) {
    jQuery('.cuked-it-step-browser-matching-steps').html(cucumberStepCompletion.matchingStepsToHtml(cucumberStep));
  },
  stepTemplateToHtmlLi: function(elementOfArray, indexInArray) {
    return "<li>" + elementOfArray + "</li>\n";
  },
  stepTemplateToHtmlTr: function(elementOfArray, indexInArray) {
    var count = cucumberStepCompletion.cucumberSteps[elementOfArray].length;
    var id = " id='step-definition-" + indexInArray + "'";
    var onClick;
    var class;

    if (count > 0) {
      onClick = " onClick='cucumberStepCompletion.toggleStepExamplesFor(" +
        indexInArray + ");'"
      class = " class='toggle closed step-definition'"
    }
    else {
      onClick = "";
      class = " class='step-definition'"
    }

    return "<tr><td><div" + class + onClick + id + ">" +
      elementOfArray +
      "</div></td><td class='number'>" + count + "</td></tr>\n";

  },
  selectFieldFromStepTemplates: function() {
    var html = "<select id='select-step' name='step'>";
    varoptions =  jQuery.map(cucumberStepCompletion.stepTemplates(),
                             cucumberStepCompletion.stepTemplateToHtmlOption);
    html += options.join('');
    html += "</select>";
    return html;
  },
  listOfStepTemplates: function() {
    var html = "<ul>";
    var items = jQuery.map(cucumberStepCompletion.stepTemplates(),
                           cucumberStepCompletion.stepTemplateToHtmlLi);
    html += items.join('');
    html += "</ul>";
    return html;
  },
  tableOfStepTemplates: function() {
    var html = "<table class='sorted cuked-it-step-definition-table'><thead><tr><th>Step definition</th><th>#&nbsp;&nbsp;&nbsp;</th></tr></thead>\n";
    html += "<tbody>\n";
    var items = jQuery.map(cucumberStepCompletion.stepTemplates(),
                           cucumberStepCompletion.stepTemplateToHtmlTr);
    html += items.join("\n");
    html += "</tbody></table>";
    return html;
  },
  insertSelectField: function(divId) {
    jQuery('#' + divId).html(cucumberStepCompletion.selectFieldFromStepTemplates());
  },
  htmlForStepBrowser: function() {
    return cucumberStepCompletion.tableOfStepTemplates();
  },
  createStepBrowser: function() {
    var html = "<div class='cuked-it-step-browser-list'>";
    html += cucumberStepCompletion.htmlForStepBrowser();
    html += "</div>";
    jQuery('.cuked-it-step-browser').html(html);
  },
  toggleStepExamplesFor: function(index) {
    var isCurrentlyClosed = $('#step-definition-' + index).hasClass('closed');
    var id = '#step-definition-' + index;
    $(id).toggleClass('open').toggleClass('closed')
    if (isCurrentlyClosed) {
      jQuery(id).append(cucumberStepCompletion.matchingStepsToHtml(index));
    }
    else {
      jQuery(id + " .matching-steps").empty();
    }
  }
}

jQuery(document).ready(cucumberStepCompletion.createStepBrowser);
jQuery(document).ready(function() {
  jQuery('table.sorted').tablesorter();
});
