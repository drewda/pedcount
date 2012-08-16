window.JqmHelpers =
  flashPopup: (objectId, milliseconds = 1500) ->
    # Note that objectId should include the leading hash.
    # For example: objectId = "#the-alert-popup"
    $(objectId).popup 'open'
    setTimeout ->
      $(objectId).popup 'close'
    , milliseconds
