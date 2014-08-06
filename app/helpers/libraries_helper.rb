module LibrariesHelper
	def status_icon(status)
		if status == Library::STATUS[0]
			status = "/assets/grey_circle.png"
		elsif status == Library::STATUS[1]
			status = "/assets/yellow_circle.png"
		elsif status == Library::STATUS[2]
			status = "/assets/green_circle.png"
		elsif status == Library::STATUS[3]
			status = "/assets/red_circle.png"
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
end
