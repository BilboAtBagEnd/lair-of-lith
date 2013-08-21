$(document).on 'page:change', ->
  url = document.location.pathname + document.location.search
  if window._gaq?
    _gaq.push ['_trackPageview', url]
  else if window.pageTracker?
    pageTracker._trackPageview(url)
