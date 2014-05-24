class SurahsController < ApplicationController
  before_action :set_memories, only: [:index, :memorize, :show, :edit, :update, :destroy]
  before_action :set_surah, only: [:memorize, :show, :edit, :update, :destroy]

  NUM_AYAHS = 6236
  ONE_DAY = 86400

  # GET /surahs
  # GET /surahs.json
  def index
    @surahs = Surah.all

    @surahs.map do |s|
		s.memory = calc_surah_memory(s)
    end

    @surahs = @surahs.sort_by { |s| -s.memory }
  end

  # POST 
  def memorize
	now = Time.new
	didnt_update = false
	
	# go through each memory and update it
	for i in (@surah.start)..(@surah.end - 1)
		m = @memories[i]

		# only allow 1 update per 24 hours
		if (now - (m.updated_at) < ONE_DAY) and m.memory > 0
			didnt_update = true 
			next
		end
			
		m.memory += 5

		m.save
	end

	# make db entry
	r = Recording.new
	r.surah_id = @surah.id
	r.user_id = current_user.id
	r.save()

	begin
		# save recording in filesystem
		audio = params[:audio]
		save_path = Rails.root.join("public/recordings/#{r.id}-#{r.created_at.to_s.sub(" ", "_")}.wav")

		File.open(save_path, 'wb') do |f|
			f.write params[:audio].read
		end
	rescue Exception => e  
		puts e.message  
		puts e.backtrace.inspect 
		r.delete()
	end


	if didnt_update
		flash[:notice] = "Only 1 update per 24 hours allowed"
	else
		flash[:notice] = "Updated successfully"
	end

	redirect_to action: 'index'
  end

  # GET /surahs/1
  # GET /surahs/1.json
  def show
  	@recordings = Recording.where(surah_id: @surah.id, user_id: current_user.id)
  end

  # GET /surahs/new
  def new
    @surah = Surah.new
  end

  # GET /surahs/1/edit
  def edit
  end

  # POST /surahs
  # POST /surahs.json
  def create
    @surah = Surah.new(surah_params)

    respond_to do |format|
      if @surah.save
        format.html { redirect_to @surah, notice: 'Surah was successfully created.' }
        format.json { render action: 'show', status: :created, location: @surah }
      else
        format.html { render action: 'new' }
        format.json { render json: @surah.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /surahs/1
  # PATCH/PUT /surahs/1.json
  def update
    respond_to do |format|
      if @surah.update(surah_params)
        format.html { redirect_to @surah, notice: 'Surah was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @surah.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /surahs/1
  # DELETE /surahs/1.json
  def destroy
    @surah.destroy
    respond_to do |format|
      format.html { redirect_to surahs_url }
      format.json { head :no_content }
    end
  end

  private
  	def set_memories 
		@memories = Memory.where(user_id: current_user.id).to_a

		if @memories.length == 0
			# create them
			@memories = []
			for i in 0..(NUM_AYAHS - 1)
				m = Memory.new
				m.memory = 0
				m.user_id = current_user.id
				m.ayah_index = i
				# add to db
				m.save
				# add to list
				@memories.push m
			end
		else
			# subtract off time interval
			now = Time.new

			@memories.each do |m|
				days_passed = (now - m.updated_at).to_i / ONE_DAY
				m.memory -= days_passed * 5
				m.memory = 0 if m.memory < 0
			end
		end

		raise "bad nums" if @memories.length != NUM_AYAHS

		@memories = @memories.sort_by { |m| m.ayah_index }
  	end

	def calc_surah_memory(surah)
		now = Time.new
		min_memory = 100

		for i in (surah.start)..(surah.end - 1)
			m = @memories[i]
			min_memory = m.memory if m.memory < min_memory
		end

		return min_memory
	end

    # Use callbacks to share common setup or constraints between actions.
    def set_surah
      @surah = Surah.find(params[:id])
	  @surah.memory = calc_surah_memory(@surah)
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def surah_params
      params.require(:surah).permit(:name, :memory, :recording)
    end

end
