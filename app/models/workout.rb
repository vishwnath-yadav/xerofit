class Workout < ActiveRecord::Base
	require 'RMagick'
	obfuscate_id :spin => 12548694
	# default_scope order('updated_at DESC')

	#has_attached_file :pic, :styles => { :medium => "300x300>", :thumb => "150x150>" ,:square => "90x90>", :p_square => "55x55>", :w_square => "130x130>"}, :default_url => "/images/:style/missing.png"
  	
	# attr_accessor :x, :y, :width, :height, :cropper_id

	# has_attached_file :pic, :styles => { :display => '550x425>', :medium => "300x300>", :thumb => "150x150>" ,:square => "90x90>", :p_square => "55x55>", :w_square => "130x130>"},:whiny_thumbnails => true, :path => 
 #                          ":rails_root/public/system/:attachment/:id/:style/:style.:extension", 
 #                          :url => "/system/:attachment/:id/:style/:style.:extension"


	# validates_attachment_content_type :pic, :content_type => /\Aimage\/.*\Z/

	has_attached_file :pic, :styles => { :small => "100x100#", :medium => "300x300#",:large => "500x500>",:thumb => "150x150>", :square => "90x90>", :p_square => "55x55>", :w_square => "130x130>" }, :processors => [:cropper]
	validates_attachment_content_type :pic, :content_type => ['image/jpeg', 'image/png', 'image/gif']
	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
	#validates :pic, :dimensions => { :width => 300, :height => 300 }, :on => :create, :if => "!pic.blank?"
	
	has_many :blocks
	has_one :statastic
	belongs_to :user

	after_create :save_status
	
	validates :title, presence: true

	STATES = [:initiated, :completed]

	scope :by_status, lambda { |status| where(status: status) unless status == "All Statuses" || status.blank? }
	scope :by_name, lambda { |name| where('title ilike ?', name+"%") unless name.blank? }
	scope :by_user, lambda { |user| where(user_id: user) unless user.blank? || user.nil? }

  
	Workout::STATES.each do |state|
	    define_method "#{state}?" do
	      self.state.try(&:to_sym) == state
	    end
	end

	def save_blocks_and_libs(block_hash)
		block_hash.each do|key, value|
			block = Block.find_by_id(key)
			block.workout_id = self.id
			block.save!
			value.each do|k, v|
				lib = Move.find_by_id(k)
				lib_block = LibraryBlock.where(:move_id=>lib.id, :block_id=>block.id).last
				if !lib_block.present?
					lib_block = LibraryBlock.new(:move_id=>lib.id, :block_id=>block.id)
					lib_block.save!
				end
				lib_detail = LibraryDetail.find(v)
				if lib_detail.present?
					lib_detail.library_block_id = lib_block.id
					lib_detail.save!
				end
			end
		end
	end

	def increase_visit
		if self.statastic.present?
			self.statastic.visits += 1
		else
			self.statastic = Statastic.new(visits: 1)
		end
		self.save
	end

	def most_popular
		Workout.joins(:statastic).where(state: "completed").order('statastics.visits DESC').limit(5)
	end

	def save_status
		self.status = Move::STATUS[4]
		self.save
	end


	# def previous_post
	#   self.class.first(:conditions => ["id < ? and user_id = ?", id, self.user_id], :order => "id desc")
	# end

	# def next_post
	#   self.class.first(:conditions => ["id > ? and user_id = ?", id,self.user_id], :order => "id asc")
	# end

	def self.workout_count
		self.all.count
	end

	def cropping?
		!crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
	end

	def pic_geometry(style = :original)
		@geometry ||= {}
		@geometry[style] ||= Paperclip::Geometry.from_file(pic.path(style))
	end

	def reprocess_pic
		pic.reprocess!
	end

	def date_updated_for_approval(new_status, old_status)
		binding.pry
		if old_status != Move::STATUS[2] && new_status == Move::STATUS[2] && !self.date_submitted_for_approval.present?
			self.date_submitted_for_approval = self.updated_at
			self.save
		end 
	end

end
