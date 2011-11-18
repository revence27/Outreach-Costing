$ ->
  armRegions()
  armComponents()

armRegions = () ->
  for reg in $('.regionnav .regionitem')
    $(reg).click((evt) ->
      regId     = evt.target.href.split('#')[1]
      ajaxOpts  =
        success: (dat, stat, rez) ->
          toile   = $('.regions')
          toile   = $(toile[0]) unless toile.length < 2
          toile.empty() if $('.region', toile).length > 0
          r1      = $('<div class="region">')
          rn      = $('<div class="regionname">')
          rn.html "Districts in the #{dat.region} region of #{dat.country}"
          di = $('<div class="districts">')
          r1.append di
          di.append rn
          for dst in dat.districts
            d1 = $('<div class="district">')
            dn = $('<div class="districtname">')
            dd = $('<div class="districtdata">')
            df = $('<form class="submitter">')
            ds = $('<input type="button">')
            ds.attr 'value', 'Process Report'
            ds.attr 'id', dst.id
            ds.click sendToGenerator
            df.append ds
            dn.html "#{dst.name} district"
            dd.html "(#{commafy dst.population.toString()})"
            dd.append df
            d1.append dn
            d1.append dd
            di.append d1
          toile.append r1
          hideSubmitters()
          armDistricts()
      $.ajax "/region/#{regId}/districts", ajaxOpts
    )

armComponents = () ->
  cps   = $(document.forms.componentform)
  for opt in $('option', cps[0])
    $(opt).click((evt) ->
      sel       = $(evt.target).parent()
      alive     = $('option:selected')
      compIds   = (x.value for x in alive)
      compId    = evt.target.value
      ajaxOpts  =
        success: (dat, stat, rez) ->
          acts = $('.activities')
          acts.empty()
          acts.append($('<div class="label">Activities</div>'))
          holder = $('<form>')
          for act in dat
            label = $("<label class='activity' for='activity#{act.id}'>")
            label.attr 'component', compId
            label.html act.name
            check = $("<input type='checkbox' value='#{act.id}' id='activity#{act.id}'>")
            fset  = $('<fieldset>')
            fset.append check
            fset.append label
            holder.append fset
          acts.append holder
          armActivities()
      $.ajax "/component/#{encodeURIComponent(JSON.stringify(compIds))}/activities", ajaxOpts
    )

armDistricts = () ->
  for dst in $('.districts .district')
    $(dst).hover(((evt) ->
      $('.submitter', evt.target).show('fast')),
      (evt) -> hideSubmitters(evt.target)
      )

armActivities = () ->
  for act in $('.activities .activity')
    $(act).click((evt) ->
      checked = ':checked'
      cbox    = $("##{$(evt.target).attr('for')}")
      cont    = $('.items', $(evt.target).parent())
      activId = cbox.attr('id').replace(/^\D+/, '')
      if cbox.is checked
        cont.empty() if cont
      else
        ajaxOpts =
          success: (dat, stat, rez) ->
            dest = $('.activities form')
            chkb = $("#activity#{activId}", dest)
            roof = chkb.parent()
            toit = $('<div class="items">')
            for item in dat
              it = $("<input type='checkbox' value='#{item.id}' checked='checked' id='activityitem#{item.id}'>")
              il = $("<label class='activityitem' for='activityitem#{item.id}'>")
              il.html item.description
              toit.append it
              toit.append il
              toit.append $ '<br />'
              roof.append toit
        $.ajax "/activity/#{activId}/items", ajaxOpts
    )

hideSubmitters = (within) ->
  for subm in $('.submitter', within)
    $(subm).hide()

sendToGenerator = (evt) ->
  them = $('.activities .activity')
  if them.length < 1
    alert 'First select a component.'
    return
  collected = {}
  enfin = []
  for it in them
    checked = ':checked'
    act     = $("##{$(it).attr('for')}")
    continue unless act.is checked
    for x in $('.activityitem', act.parent())
      slc = $("##{$(x).attr('for')}")
      enfin.push(slc.attr('value')) if slc.is checked
    collected[act.attr('id').replace(/^\D+/, '')] = enfin
  unless enfin.length > 0
    alert 'First select at least one activity item.'
    return
  data =
    components: (x.value for x in $('option:selected', document.forms.componentform))
    district: $(evt.target).attr('id')
    selection: collected
  # destination = "/generate/#{$(evt.target).attr('id')}/#{encodeURIComponent(JSON.stringify data)}"
  ajaxOpts =
    success: (dat, stat, rez) ->
      stdout = $ '#stdout'
      stdout.addClass 'stdout'
      stdout.html(dat)
      document.location.hash = stdout.attr 'id'
  # $.ajax destination, ajaxOpts
  $.post("/generate/#{data.district}", {relations: encodeURIComponent(JSON.stringify data)}, ajaxOpts.success)

commafy = (str) ->
  if str.length < 4
    return str
  commafy(str.substring(0, str.length - 3)) + ',' + str.substring(str.length - 3)
