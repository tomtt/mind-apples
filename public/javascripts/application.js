// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function show_share_this_icons()
{ 
  document.getElementById("share_this_links").style.display="inline";
}

document.observe("dom:loaded", function() {
  if($("person_password"))
    $("person_password").value = ''
});
