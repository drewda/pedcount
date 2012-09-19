window.JqmHelpers =
  flashPopup: (objectId, milliseconds = 1500) ->
    # Note that objectId should include the leading hash.
    # For example: objectId = "#the-alert-popup"
    $(objectId).popup 'open'
    setTimeout ->
      $(objectId).popup 'close'
    , milliseconds
   flashPopupAndChangePage: (objectId, newPageHash, milliseconds = 1500) ->
    # Note that both the objectId and the newPageHash should include the leading hash.
    # For example: objectId = "#the-alert-popup" and newPageHash = "#open-project"
    $(objectId).popup 'open'
    setTimeout ->
      $(objectId).popup 'close'
      $.mobile.changePage newPageHash
    , milliseconds
