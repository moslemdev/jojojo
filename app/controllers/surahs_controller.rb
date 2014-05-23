class SurahsController < ApplicationController
  before_action :set_surah, only: [:show, :edit, :update, :destroy]

  # GET /surahs
  # GET /surahs.json
  def index
    @surahs = Surah.all
  end

  # GET /surahs/1
  # GET /surahs/1.json
  def show
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
    # Use callbacks to share common setup or constraints between actions.
    def set_surah
      @surah = Surah.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def surah_params
      params.require(:surah).permit(:name, :memory)
    end
end
