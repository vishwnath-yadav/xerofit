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
end
