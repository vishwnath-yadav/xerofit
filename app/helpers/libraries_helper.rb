module LibrariesHelper
	def status_icon(status)
		if status == Library::STATUS[0]
			status = "/assest/grey_circle.png"
		elsif status == Library::STATUS[1]
			status = "/assest/yellow_circle.png"
		elsif status == Library::STATUS[2]
			status = "/assest/green_circle.png"
		elsif status == Library::STATUS[3]
			status = "/assest/red_circle.png"
		end
	end
end
