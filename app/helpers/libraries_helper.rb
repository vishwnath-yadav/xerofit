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
end
