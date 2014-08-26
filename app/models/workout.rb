class Workout < ActiveRecord::Base
	require 'RMagick'
	obfuscate_id :spin => 12548694
	# default_scope order('updated_at DESC')

	#has_attached_file :pic, :styles => { :medium => "300x300>", :thumb => "150x150>" ,:square => "90x90>", :p_square => "55x55>", :w_square => "130x130>"}, :default_url => "/images/:style/missing.png"
  	
	attr_accessor :x, :y, :width, :height, :cropper_id

	has_attached_file :pic, :styles => { :display => '300x200', :medium => "300x300>", :thumb => "150x150>" ,:square => "90x90>", :p_square => "55x55>", :w_square => "130x130>"},:whiny_thumbnails => true, :path => 
                          ":rails_root/public/system/:attachment/:id/:style/:style.:extension", 
                          :url => "/system/:attachment/:id/:style/:style.:extension"


	validates_attachment_content_type :pic, :content_type => /\Aimage\/.*\Z/
	validates :pic, :dimensions => { :width => 300, :height => 300 }, :on => :create, :if => "!pic.blank?"
	
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
				lib = Library.find_by_id(k)
				lib_block = LibraryBlock.where(:library_id=>lib.id, :block_id=>block.id).last
				if !lib_block.present?
					lib_block = LibraryBlock.new(:library_id=>lib.id, :block_id=>block.id)
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
		self.status = Library::STATUS[4]
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

	def update_photo_attributes(att)
    scaled_img = Magick::ImageList.new(self.pic.path)
    orig_img = Magick::ImageList.new(self.pic.path(:original))
    scale = orig_img.columns.to_f / scaled_img.columns
    args = [ att[:x1], att[:y1], att[:width], att[:height] ]
    args = args.collect { |a| a.to_i * scale }
    orig_img.crop!(*args)
    orig_img.write(self.pic.path(:original))
    self.pic.reprocess!
    self.save
  end

end
