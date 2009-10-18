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
  selectFieldFromStepTemplates: function() {
    html = "<select id='select-step' name='step'>";
    options =  jQuery.map(cucumberStepCompletion.stepTemplates(), 
                          cucumberStepCompletion.stepTemplateToHtmlOption);
    html += options.join('');
    html += "</select>";
    return html;
  },
  insertSelectField: function(divId) {
    jQuery('#' + divId).html(cucumberStepCompletion.selectFieldFromStepTemplates());
  }
}
