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
		if library.new_record? || library.target_muscle_groups[i].target_muscle_group.blank?
	      "Choose #{abc}"
        else
          library.target_muscle_groups[i].target_muscle_group 
      	end
	end

	def trg_hide(library,i)
		library.target_muscle_groups[i].target_muscle_group.blank? ? 'dis_non' : 'dis_blk'
	end

	def trg_count(library,i)
		i==(library.target_muscle_groups.map{|m| m.target_muscle_group}-["",nil]).count ? ' active' : ''
	end
end
