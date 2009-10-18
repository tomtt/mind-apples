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
  stepTemplateToHtmlLi: function(elementOfArray, indexInArray) {
    return "<li>" + elementOfArray + "</li>\n";
  },
  selectFieldFromStepTemplates: function() {
    html = "<select id='select-step' name='step'>";
    options =  jQuery.map(cucumberStepCompletion.stepTemplates(), 
                          cucumberStepCompletion.stepTemplateToHtmlOption);
    html += options.join('');
    html += "</select>";
    return html;
  },
  listOfStepTemplates: function() {
    html = "<ul>";
    items =  jQuery.map(cucumberStepCompletion.stepTemplates(), 
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
    html = "<div class='cuked-it-step-browser-list'>";
    html += cucumberStepCompletion.htmlForStepBrowser();
    html += "</div>";
    html += "<div class='cuked-it-step-browser-matching-steps'></div>";
    jQuery('.cuked-it-step-browser').html(html);
  }
}

jQuery(document).ready(cucumberStepCompletion.createStepBrowser);
