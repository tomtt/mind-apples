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
  displayMatchingStepsFor: function(cucumberStep) {
    var stepDefinition = cucumberStepCompletion.cachedSteps[cucumberStep];
    var matchingSteps = cucumberStepCompletion.cucumberSteps[stepDefinition];
    var matchingStepsItems = jQuery.map(matchingSteps, cucumberStepCompletion.stepMatchToHtml);
    var html = "<b>" +  stepDefinition + " </b>(" + matchingStepsItems.length + ")\n<ul>";
    html += matchingStepsItems.join("\n");
    html += "</ul>";
    jQuery('.cuked-it-step-browser-matching-steps').html(html);
  },
  stepTemplateToHtmlLi: function(elementOfArray, indexInArray) {
    return "<li onMouseOver='cucumberStepCompletion.displayMatchingStepsFor(" + indexInArray + ");'>" + elementOfArray + "</li>\n";
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
  insertSelectField: function(divId) {
    jQuery('#' + divId).html(cucumberStepCompletion.selectFieldFromStepTemplates());
  },
  htmlForStepBrowser: function() {
    return cucumberStepCompletion.listOfStepTemplates();
  },
  createStepBrowser: function() {
    var html = "<div class='cuked-it-step-browser-list'>";
    html += cucumberStepCompletion.htmlForStepBrowser();
    html += "</div>";
    html += "<div class='cuked-it-step-browser-matching-steps'></div>";
    jQuery('.cuked-it-step-browser').html(html);
  }
}

jQuery(document).ready(cucumberStepCompletion.createStepBrowser);
