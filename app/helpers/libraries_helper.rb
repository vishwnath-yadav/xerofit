module LibrariesHelper
	def status_icon(status)
		if status == Library::STATUS[0]
			status = "/assets/icons/status_icon_green.png"
		elsif status == Library::STATUS[1]
			status = "/assets/icons/status_icon_red.png"
		elsif status == Library::STATUS[2]
			status = "/assets/icons/status_icon_yellow.png"
		elsif status == Library::STATUS[3]
			status = "/assets/icons/status_icon_purple.png"
		elsif status == Library::STATUS[4]
			status = "/assets/icons/status_icon_gray.png"
		end
	end

	def get_select_val(library, i, abc)
		tgm = library.target_muscle_groups[i]
		if library.new_record? || tgm.sub_target_muscle_group.blank?
	      "Choose #{abc}"
        else
          (tgm.sub_target_muscle_group.include? "All") ? tgm.sub_target_muscle_group : "#{tgm.target_muscle_group} #{tgm.sub_target_muscle_group}"
      	end
	end

	def trg_hide(library,i, count)
		if (i<=1)&&(count == 5)
			'dis_blk'
		else
			library.target_muscle_groups[i].target_muscle_group.blank? ? 'dis_non' : 'dis_blk'
		end
	end

	def trg_count(library,i, count)
		if (i==2)&&(count == 5)
			'active'
		else
			i == (5 - count) ? ' active' : ''
		end
	end

	def get_order_hash(param)
		if params[:sorted_by] == 'title'
			title_order = param[:order].blank? || param[:order] == 'ASC' ? 'DESC' : 'ASC'
		  title_arrow = param[:order].blank? || param[:order] == 'ASC' ? 'ascending' : 'descending'
			date_order = ''
			date_arrow = ''
		else
			date_order = param[:order].blank? || param[:order] == 'ASC' ? 'DESC' : 'ASC'
		  date_arrow = param[:order].blank? || param[:order] == 'ASC' ? 'ascending' : 'descending'
		  title_order = ''
		  title_arrow = ''
		end
		return{'title_arrow' => title_arrow, 'title_order' => title_order, 'date_arrow' => date_arrow, 'date_order' => date_order}
	end
end
