$(document).on 'page:change', ->
  if window.clicky?
    clicky.log( document.location.pathname + document.location.query, document.title, 'pageview' );
