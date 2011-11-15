activeComponent = 0

$ ->
  armRegions()
  armComponents()
  armDistricts()
  hideSubmitters()

armRegions = () ->
  for reg in $('.regions .regionnav .regionitem')
    $(reg).click((evt) ->
      regId     = evt.target.href.split('#')[1]
      ajaxOpts  =
        success: (dat, stat, rez) ->
          toile   = $('.regions')
          toile.empty() if $('.region', toile).length > 1
          r1      = $('<div class="region">')
          rn      = $('<div class="regionname">')
          rn.html "Districts in the #{dat.region} region of #{dat.country}"
          di = $('<div class="districts">')
          r1.append di
          for dst in dat.districts
            d1 = $('<div class="district">')
            dn = $('<div class="districtname">')
            dd = $('<div class="districtdata">')
            df = $('<form class="submitter">')
            ds = $('<input type="button">')
            ds.attr 'value', 'Process Report'
            ds.click((evt) ->
              alert 'TODO: Send to report generator.'
              )
            df.append ds
            dn.html "#{dst.name} district"
            dd.html "Population: #{dst.population}"
            dd.append df
            d1.append dn
            d1.append dd
            di.append d1
          toile.append r1
          hideSubmitters()
          armDistricts()
      $.ajax "/region/#{regId}/districts.json", ajaxOpts
    )

armComponents = () ->
  cps   = $('componentform')
  for opt in $('option', cps[0])
    $(opt).click((evt) ->
      compId = evt.target.value
      ajaxOpts =
        success: (dat, stat, rez) ->
          acts = $('.activities')
          acts.empty()
          acts.append($('<div class="label">Activities</div>'))
          holder = $('<form>')
          for act in dat
            label = $("<label class='activity' for='activity#{act.id}'>")
            label.html act.name
            check = $("<input type='checkbox' value='#{act.id}' id='activity#{act.id}' checked='checked'>")
            holder.append check
            holder.append label
          acts.append holder
      $.ajax "/component/#{compId}/activities", ajaxOpts
    )

armDistricts = () ->
  for dst in $('.districts .district')
    $(dst).hover(((evt) ->
      $('.submitter', evt.target).show('fast')),
      (evt) -> hideSubmitters(evt.target)
      )

hideSubmitters = (within) ->
  for subm in $('.submitter', within)
    $(subm).hide()
