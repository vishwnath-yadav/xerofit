class Workout < ActiveRecord::Base
	require 'RMagick'
	obfuscate_id :spin => 12548694
	
	attr_accessor :crop_x, :crop_y, :crop_w, :crop_h, :pic_creating

	has_many :blocks
	has_many :histories
	has_one :statastic
	belongs_to :user
	has_attached_file :pic, 
	:styles => { :small => "100x100#", :extra_large => "800x800>", :medium => "300x300#", :large => "500x500>", :thumb => "150x150>", :square => "90x90>", :p_square => "55x55>", :w_square => "130x130>" },
	:processors => [:cropper],
	:storage => :s3, 
	:path => "/image/workout/:id/:style/:filename",
	:s3_credentials => Proc.new{|a| a.instance.s3_credentials }

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
  
  def s3_credentials
    { :bucket => Settings.aws.bucket, 
      :access_key_id => Settings.aws.access_key_id, 
      :secret_access_key => Settings.aws.secret_access_key}
  end

	def save_number_of_moves(number_of_moves)
		if number_of_moves.present?
			count = number_of_moves
			self.number_of_moves = count.to_i
		end
	end

	def save_blocks(block)
		if block.present?
			block_hash = block
			self.save_blocks_and_libs(block_hash)
			self.state = "completed"
		end
	end
		

	def save_blocks_and_libs(block_hash)
		block_hash.each do|key, value|
			block = Block.find_by_id(key)
			block.workout_id = self.id
			block.save!

			if value.present?
				value.each do|k, v|
					unless k=='0' && v=='0'
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
		end
	end

	def change_status
		if self.has_full_detail && self.number_of_moves >= 7
			self.status = Move::STATUS[3]
		end
	end

	def save_index_hash(indexes)
		ids = indexes.split(",")
		ids.each_with_index do |id, ind|
			Block.update([id], [sort_index: ind.to_i])
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
		self.move_type = Move::TYPE[2]
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
    @geometry[style] ||= Paperclip::Geometry.from_file(pic.url(style))
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

	def self.avg_workout_counts(workout_count,trainer_count)
		if workout_count != 0
			(workout_count/trainer_count).to_i
		else
			return 0 
		end
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

	def has_full_detail
		if [Move::STATUS[0],Move::STATUS[2],Move::STATUS[3]].include? (self.status)
			return true
		else
			attributes = [self.title, self.subtitle, self.description, self.status]
			req = attributes & [nil, ""]
			req.size == 0 
		end
	end

	private
	def validate_image
   		self.pic? && !self.pic_creating.blank?	
	end

end
