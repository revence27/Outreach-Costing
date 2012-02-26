$ ->
  $('#throbber').text('Loading ...').hide()
  armRegions()
  armComponents()
  armAssumptionValues()
  armDistrictPopulations()
  hideSettings()

armRegions = () ->
  for reg in $('.regionnav .regionitem')
    $(reg).click((evt) ->
      $('#throbber').show()
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
            d1 = $("<div class='district' id='district_#{dst.id}'>")
            dn = $('<div class="districtname">')
            dd = $('<div class="districtdata">')
            df = $('<form class="submitter">')
            ds = $('<input type="button">')
            ss = $("<a href='#district_#{dst.id}' style='font-size: x-small; margin-left: 1em; margin-right: 1em;'>Show #{dst.name} HSDs</a>")
            ds.attr 'value', 'Process Report'
            ds.attr 'id', dst.id
            ds.click sendToGenerator
            df.append ss
            df.append ds
            dn.html "#{dst.name} district"
            dd.html "(#{commafy dst.population.toString()})"
            dd.append df
            d1.append dn
            d1.append dd
            di.append d1

            subds   = $('<div class="subdistrict">')
            parter1 = $('<td width="30%">')
            subds.hide()
            for subd  in  dst.subdistricts
              subdist = $("<a href='##{subd.id}' style='display:block'>#{subd.name}</a>")
              subdist.click((evt) ->
                parterr   = $(evt.target).parent().parent()
                parter2   = $($('td', parterr)[1])
                parter2.text 'Loading sub-counties ...'
                entege =
                  success: (dat, stat, rez) ->
                    parterr   = $(evt.target).parent().parent()
                    parter2   = $($('td', parterr)[1])
                    parter2.empty()
                    subcform  = $('<form>')
                    subcsel   = $('<select>')
                    fset      = $('<fieldset>')
                    fset.append $("<legend>#{dat.hsd} Sub-Counties</legend>")
                    fset.append subcsel
                    subcsel.append $('<option selected="selected" disabled="disabled">Select a sub-county to see its parishes.</option>')
                    subcform.append fset
                    parter2.append subcform
                    subcsel.change((evt) ->
                      elform  = $(evt.target).parent().parent().parent()
                      $('.multipleparish', elform).hide()
                      $("#parish_#{$(evt.target).attr('value')}").show('fast')
                    )
                    for subc in dat.subcounties
                      paropt  = $("<option value='#{subc.id}'>")
                      paropt.text subc.name
                      subcsel.append paropt
                      psel    = $("<select multiple='multiple'>")
                      fset2   = $("<fieldset id='parish_#{subc.id}'
                                    class='multipleparish'>")
                      fset2.append '<legend></legend>'
                      psel.append $('<option disabled="disabled">Select a parish to see its health units.</option>')
                      psel.change((evt) ->
                        $('ol', $(evt.target).parent().parent()).hide()
                        hunit = $("#healthunits_#{$(evt.target).attr('value')}")
                        hunit.show('fast')
                      )
                      for par in subc.parishes
                        popt = $("<option value='#{par.id}'>")
                        hulist  = $("<ol id='healthunits_#{par.id}'>")
                        for hun in par.healthunits
                          li  = $('<li>')
                          if hun.status == 'NON  FUNCTIONAL'
                            ln  = $("<del id='hunlink_#{hun.id}'>")
                          else
                            ln  = $("<a href='javascript:;' id='hunlink_#{hun.id}'>")
                            loadCong = (evt) ->
                              lien  = $(evt.target)
                              leg   = $('legend', lien.parent().parent().parent())
                              leg.html('<i>Loading ...</i>')
                              congregator =
                                success: (dat, stat, rez) ->
                                  if dat.congregations < 1
                                    lien.parent().prepend('<div><small><i>No liaison with any place of worship yet.</i></small></div>')
                                  else
                                    alert dat.congregations
                                  leg.html ''
                              $.ajax "/hu/#{lien.attr('id').split('_')[1]}/congregations", congregator
                          ln.click loadCong
                          ln.html "#{hun.name} <i>(#{hun.level})</i>"
                          li.append ln
                          hulist.append li
                          fset2.append hulist
                        popt.text "#{par.name} (#{par.healthunits.length})"
                        psel.append popt
                        hulist.hide()
                      fset2.hide()
                      fset2.append psel
                      subcform.append fset2
                $.ajax "/hsd/#{$(evt.target).attr('href')[1 ..]}/subcounties", entege
                # $(evt.target).parent().hide('fast')
              )
              parter1.append subdist
            parter2 = $('<td width="70%">')
            parterr = $('<tr>')
            partert = $('<table>')
            parterr.append parter1
            parterr.append parter2
            partert.append parterr
            subds.append partert

            ss.click((evt) ->
              $('.subdistrict').hide()
              sub = $('.subdistrict', $(evt.target).parent().parent().parent())
              sub.show('fast')
            )
            d1.append subds
          toile.append r1
          $('#throbber').hide()
          hideSubmitters()
          armDistricts()
      $.ajax "/region/#{regId}/districts", ajaxOpts
    )

armComponents = () ->
  cps   = $(document.forms.componentform)
  for opt in $('option', cps[0])
    $(opt).click((evt) ->
      $('#throbber').show()
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
          $('#throbber').hide()
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
      $('#throbber').show()
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
            $('#throbber').hide()
        $.ajax "/activity/#{activId}/items", ajaxOpts
    )

hideSubmitters = (within) ->
  for subm in $('.submitter', within)
    $(subm).hide()

sendToGenerator = (evt) ->
  $('#throbber').show()
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
  ajaxOpts =
    success: (dat, stat, rez) ->
      stdout = $ '#stdout'
      stdout.addClass 'stdout'
      stdout.html(dat)
      document.location.hash = stdout.attr 'id'
      $('#throbber').hide()
  $.post("/generate/#{data.district}", {relations: encodeURIComponent(JSON.stringify data)}, ajaxOpts.success)

commafy = (str) ->
  if str.length < 4
    return str
  commafy(str.substring(0, str.length - 3)) + ',' + str.substring(str.length - 3)

armAssumptionValues = () ->
  for ass in $('.assumption')
    valeur = true
    for t, sec in $('td', ass)[1 ..]
      teed = $(t)
      teed.click((e) ->
        tg = $(e.target)
        return if tg.get(0).tagName.toLowerCase() != 'td'
        if (f = $('form', tg)).length > 0
          for f1 in f
            f1.show()
            return
        carte  = $('<fieldset>')
        bouton = $('<input type="button" value="Record Changes">')
        bouton.click((ev) ->
          formulaire = $(ev.target.form)
          cellule    = formulaire.parent()
          rang       = formulaire.parent().parent()
          assid      = rang.attr('id').split('_')[1]
          decl       = $('<strong>Saving ...</strong>')
          formulaire.prepend decl
          donees     =
            type: 'POST'
            success: (dat, stat, rez) ->
              decl.text 'Saved!'
              formulaire.hide('slow', ->
                decl.remove()
                formulaire.parent().text($('input', formulaire)[0].value)
              )
          $.ajax "/record/assumption/#{assid}/#{cellule.attr('class').split('_')[1]}/#{$('input[type=text]:first-child', ev.target.form).attr('value')}", donees
        )
        editor = $('<input type="text">')
        editor.attr 'value', tg.text().trim()
        tg.append $('<form>').append(carte.append(editor).append(bouton))
        editor.focus()
      )
      valeur = not valeur

armDistrictPopulations = () ->
  rangspop  = $('.populations tr')
  for r in rangspop
    teed = $('td:last-child', r)
    teed.click((e) ->
      tg = $(e.target)
      return if tg.get(0).tagName.toLowerCase() != 'td'
      if (f = $('form', tg)).length > 0
        for f1 in f
          f1.show()
          return
        return
      carte  = $('<fieldset>')
      bouton = $('<input type="button" value="Record Changes">')
      bouton.click((ev) ->
        formulaire = $(ev.target.form)
        cellule    = formulaire.parent()
        rang       = formulaire.parent().parent()
        assid      = rang.attr('id').split('_')[1]
        decl       = $('<strong>Saving ...</strong>')
        formulaire.prepend decl
        donees     =
          type: 'POST'
          success: (dat, stat, rez) ->
            decl.text 'Saved!'
            formulaire.hide('slow', ->
              decl.remove()
              formulaire.parent().text($('input', formulaire)[0].value)
            )
        $.ajax "/record/district/#{assid}/#{$('input[type=text]:first-child', ev.target.form).attr('value')}", donees
      )
      editor = $('<input type="text">')
      editor.attr 'value', tg.text().trim()
      tg.append $('<form>').append(carte.append(editor).append(bouton))
      editor.focus()
    )
    valeur = not valeur

hideSettings = () ->
  boite = $('#settingsnav')
  for s, i in $('.settingspanel')
    paneau  = $(s)
    titre   = $('.settingsheading', s)
    lien    = $('<a class="settingslien" href="#' + i + '"> ')
    lien.html(titre.html())
    boite.append lien
    paneau.hide()
    lien.click((evt) ->
      cluck   = $(evt.target)
      pos     = parseInt(cluck.attr('href').split('#')[1])
      paneaux = $('.settingspanel')
      paneaux.hide()
      $(paneaux[pos]).show('fast')
    )
