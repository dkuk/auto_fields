


document.observe('dom:loaded', function(){
	hide_issue_fields(true);
	disable_issue_fields();
	require_issue_fields();
	hide_trackers();
	

	if($('issue_status_id')!=undefined)
		{
		Event.observe('issue_status_id', 'change', function(event) {
			hide_issue_fields(true);
			disable_issue_fields();
			require_issue_fields();
			});
		}

	
	});

function hide_trackers()
	{
	if (($('issue_tracker_id')!=undefined))
		{
		var available_tracker_ids=[];
		var current_tracker_id=$('current_tracker_id').innerHTML;
		available_tracker_ids=$$('.hidden_trackers')[0].innerHTML.split(", ");
		if($F('issue_subject')!='')
			var edit=true;
		else
			var edit=false;
			
		$('issue_tracker_id').select('option').each(function(e){
			if(!(available_tracker_ids.indexOf(e.getAttribute('value'))+1))
				{
				if(edit)
					{
					if(current_tracker_id!=e.getAttribute('value')) //Если это выбраное значение
						{
						e.remove();
						}
					}
				else
					{
					e.remove();
					}
				}
			});
		
		if((!(available_tracker_ids.indexOf(current_tracker_id)+1))&&edit) //Если выбраного значения нет в доступных трекерах и форма редактирования
			{
			$('issue_tracker_id').select('option').each(function(e){
				if(current_tracker_id!=e.getAttribute('value'))
					{
					e.remove();
					}
				});
			}
		}
	}
	
function require_issue_fields()
	{
	
	$$('.af_required').each(function(e){
		e.removeClassName('af_required');
		e.previous().select("span")[0].remove();
		//var label=e.previous().innerHTML+"";
		//$(i).previous().innerHTML=label+"<span class='required'> *</span>";
		});
	
	var statuses=[];
	var trackers=[];
	var fields=[];
	var c_fields=[];
	if (($('issue_tracker_id')!=undefined) && ($('issue_status_id')!=undefined))
		{
		$$('.required_fields div.item').each(function(e){
			statuses=e.select('div.status_id')[0].innerHTML.split(", ");
			if((statuses.indexOf($F('issue_status_id'))+1)||(statuses.indexOf("0")+1))
				{
				trackers=e.select('div.tracker_id')[0].innerHTML.split(", ");
				if((trackers.indexOf($F('issue_tracker_id'))+1)||(trackers.indexOf("0")+1))
					{
					if(e.select('div.fields')!="")
						fields=e.select('div.fields')[0].innerHTML.split(", ");	
					if(e.select('div.c_fields')!="")	
						c_fields=e.select('div.c_fields')[0].innerHTML.split(", ");				
					all_fields = fields.concat(c_fields);		
					
					all_fields.each(function(i) {
						if($(i)!=null)
							{
							switch(i)
								{
								case 'notes':
								break;
								case 'issue_description':
								break;
								
								default:
									
									//if(!(label.indexOf("*</span>")+1))
									var label=$(i).previous().innerHTML+"";
									
									if(!(label.indexOf("*</span>")+1))
										{
										$(i).addClassName('af_required');
										$(i).previous().innerHTML=label+"<span class='required'> *</span>";
										}
									
										
								}
							}
						});

					}
				}
			});
		}
	}	
	
function disable_issue_fields()
	{
	
	$$('.af_disable').each(function(e){
		e.enable().removeClassName('af_disable');
		if(e.next()!=undefined)
			{
			if((e.next().tagName=="A")||(e.next().tagName=="IMG"))
				e.next().show();
			}
		});
	
	var statuses=[];
	var trackers=[];
	var fields=[];
	var c_fields=[];
	if (($('issue_tracker_id')!=undefined) && ($('issue_status_id')!=undefined))
		{
		$$('.disabled_fields div.item').each(function(e){
			statuses=e.select('div.status_id')[0].innerHTML.split(", ");
			if((statuses.indexOf($F('issue_status_id'))+1)||(statuses.indexOf("0")+1))
				{
				trackers=e.select('div.tracker_id')[0].innerHTML.split(", ");
				if((trackers.indexOf($F('issue_tracker_id'))+1)||(trackers.indexOf("0")+1))
					{
					if(e.select('div.fields')!="")
						fields=e.select('div.fields')[0].innerHTML.split(", ");	
					if(e.select('div.c_fields')!="")	
						c_fields=e.select('div.c_fields')[0].innerHTML.split(", ");				
					all_fields = fields.concat(c_fields);
					if(e.select('div.all_form')!="")
						{
						$('issue-form').select('input[type!="hidden"], select, textarea').each(function(i) {
							i.disable().addClassName('af_disable');		
							if(i.next()!=undefined)
								{
								if((i.next().tagName=="A")||(i.next().tagName=="IMG"))
									i.next().hide();
								}
							});
						$('issue-form').select('input[type="submit"], #notes').each(function(i) {i.enable().removeClassName('af_disable'); });
						}				
					
					all_fields.each(function(i) {
						if($(i)!=null)
							{
							switch(i)
								{
								case 'attachments_fields':

								break;
								
								default:
									$(i).disable().addClassName('af_disable');
									if($(i).next()!=undefined)
										{
										if($(i).next().type=="checkbox")
											{
											$(i).next().disable().addClassName('af_disable');
											}
										if(($(i).next().tagName=="A")||($(i).next().tagName=="IMG"))
											$(i).next().hide();
										}									
										
								}
							}
						});

					}
				}
			});
		}
	}
	
function hide_issue_fields(fieldset_hide_too)
	{
	$$('.af_hidden').each(function(e){
		e.show().removeClassName('af_hidden');
		});
	
	var statuses=[];
	var trackers=[];
	var fields=[];
	var c_fields=[];

	if (($('issue_tracker_id')!=undefined) && ($('issue_status_id')!=undefined))
		{
		$$('.hidden_fields div.item').each(function(e){
			statuses=e.select('div.status_id')[0].innerHTML.split(", ");
			if((statuses.indexOf($F('issue_status_id'))+1)||(statuses.indexOf("0")+1))
				{
				trackers=e.select('div.tracker_id')[0].innerHTML.split(", ");
				if((trackers.indexOf($F('issue_tracker_id'))+1)||(trackers.indexOf("0")+1))
					{
					if(e.select('div.fields')!="")
						fields=e.select('div.fields')[0].innerHTML.split(", ");	
					if(e.select('div.c_fields')!="")	
						c_fields=e.select('div.c_fields')[0].innerHTML.split(", ");				
					all_fields = fields.concat(c_fields);
					if(e.select('div.all_form')!="")
						{
						$('issue-form').select('input[type="text"], input[type="checkbox"], select').each(function(i) {
							if(i.up(0).tagName!="FORM" && i.up(1).getAttribute('id')!="attachments_fields")
								{
								i.up(0).hide()
									   .addClassName('af_hidden');			
								}
							});
						$('attachments_fields').up(0).hide().addClassName('af_hidden');
						$('issue-form').select('fieldset')[0].hide().addClassName('af_hidden');
						$('issue-form').select('fieldset')[1].hide().addClassName('af_hidden');
						}				
					
					all_fields.each(function(i) {
						if($(i)!=null)
							{
							switch(i)
								{
								case 'notes':
									$(i).up(0).hide()
											  .addClassName('af_hidden');
									$(i).up(0).previous().hide()
														 .addClassName('af_hidden');
								break;
								
								case 'issue_description':
									$(i).up(2).hide()
											  .addClassName('af_hidden');
								break;
								case 'issue_is_private':
									$(i).up(1).hide()
											  .addClassName('af_hidden');
								break;							
								
								case 'issue_tags':
									$(i).hide()
										.addClassName('af_hidden');
								break;		
								case 'issue_checklist_form':
									$(i).hide()
										.addClassName('af_hidden');
								break;
								case 'watchers_form':
									$(i).hide()
										.addClassName('af_hidden');
								break;							
								default:
									$(i).up(0).hide()
											  .addClassName('af_hidden');
								}
							}
						});

					}
				}
			});
		}
		
		if(fieldset_hide_too)
			{

			$('issue-form').select('fieldset').each(function(f) {
				if(f.select('p.af_hidden input[type!=hidden],  p.af_hidden textarea, div.af_hidden textarea').length == f.select('p input[type!=hidden], p textarea, div textarea').length)
					{
					f.hide().addClassName('af_hidden');
					}
				});
			if($('issue-form').select('fieldset.af_hidden').length == $('issue-form').select('fieldset').length)
				{
				if($('update'))
					$('update').hide().addClassName('af_hidden');
				if($('content').select('div.contextual a.icon-edit').first())
					$('content').select('div.contextual a.icon-edit').first().hide().addClassName('af_hidden');
				}
			}
	}
	
