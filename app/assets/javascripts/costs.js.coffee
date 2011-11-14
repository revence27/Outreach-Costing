activeComponent = 0

$ ->
  armComponents()

armComponents = () ->
  for compLink in $('.component a')
    $(compLink).click((evt) ->
      evt.preventDefault()
      id = $(evt.target).parent().attr('href').split('#')[1]
      compContainer = $(evt.target).parent().parent().parent()
      actses = $('.activities', compContainer)
      return unless actses.length > 0
      acts = $(actses[0])
      them = $('.activity', acts)
      # TODO: Toggle +/- symbol.
      # TODO: Toggle which component shows.
      activeComponent = id
      return unless them.length < 1
      compContainer.componentID = id
      requestHash =
        success:(newActivities, status, etc) ->
          holder = $('<form class="plainjaneform">')
          for newac in newActivities
            activCheck = $("<input type='checkbox' name='activity' value='#{newac.id}' id='activity#{newac.id}'>")
            activLabel = $("<label for='activity#{newac.id}' type='checkbox' name='activity'>")
            bag = $('<div class="activity">')
            bag.append activCheck
            bag.append newac.name
            activLabel.append bag
            holder.append activLabel
          acts.append holder
      $.ajax "/component/#{id}/activities.json", requestHash
    )
