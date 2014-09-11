class Workout < ActiveRecord::Base
	require 'RMagick'
	obfuscate_id :spin => 12548694
	
	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :pic_creating

	has_many :blocks
	has_many :histories
	has_one :statastic
	belongs_to :user
	has_attached_file :pic, :styles => { :small => "100x100#", :medium => "300x300#",:large => "500x500>",:thumb => "150x150>", :square => "90x90>", :p_square => "55x55>", :w_square => "130x130>" }, :processors => [:cropper]

	after_create :save_status
	
	validates_attachment_content_type :pic, :content_type => ['image/jpeg', 'image/png', 'image/gif']
	validates :title, presence: true
	validates :pic, :dimensions => { :width => 500, :height => 500 }, if: :validate_image

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
				lib_block = MoveBlock.where(:move_id=>lib.id, :block_id=>block.id).last
				if !lib_block.present?
					lib_block = MoveBlock.new(:move_id=>lib.id, :block_id=>block.id)
					lib_block.save!
				end
				lib_detail = MoveDetail.find(v)
				if lib_detail.present?
					lib_detail.move_block_id = lib_block.id
					lib_detail.save!
				end
			end
		end
	end

	def min_image_size
		"500x500"
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
		self.move_type = Move::TYPE[1]
		self.save
	end

	def self.workout_count
		self.count
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
		if old_status != Move::STATUS[2] && new_status == Move::STATUS[2] && !self.date_submitted_for_approval.present?
			self.date_submitted_for_approval = self.updated_at
			self.save
			user = User.where(:role=> "admin").pluck(:email)
			Emailer.status_mail_to_admin(self, user).deliver
		end 
		if old_status != new_status
			self.history_create()
		end
	end

	def history_create
		@history = History.new
	  	@history.workout_id = self.id
	  	@history.status = self.status
	  	@history.save
	end

	def self.avg_workout_counts
		(self.workout_count/User.trainer_count).to_i
	end

	def self.approve_status_count
		self.where(status: Move::STATUS[0]).count
	end

	def self.attention_status_count
		self.where(status: Move::STATUS[1]).count
	end

	def self.waiting_status_count
		self.where(status: Move::STATUS[2]).count
	end

	def self.ready_status_count
		self.where(status: Move::STATUS[3]).count
	end

	def self.saved_status_count
		self.where(status: Move::STATUS[4]).count
	end

	private
	def validate_image
   		self.pic? && !self.pic_creating.blank?	
	end

end
