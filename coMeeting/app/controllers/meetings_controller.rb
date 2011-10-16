class MeetingsController < ApplicationController
	before_filter :set_locale
 
	def set_locale
	  I18n.locale = params[:locale] || I18n.default_locale
	end
	
	# GET /meetings
	# GET /meetings.json
	def index
		@meetings = Meeting.all

		respond_to do |format|
			format.html { render html: @meetings } # index.html.erb
			format.json { render json: @meetings }
		end
	end

	# GET /meetings/1
	# GET /meetings/1.json
	def show
		@meeting = Meeting.find_by_link_admin(params[:id])
		if @meeting == nil
			respond_to do |format|
				format.html { redirect_to root_path, notice: t("no_meeting", :default => "The meeting you're looking for doesn't exist!") }
			end
		else
			respond_to do |format|
				format.html # show.html.erb
				format.json { render json: @meeting }
			end
		end
	end


	# GET /meetings/new
	# GET /meetings/new.json
	def new
		@meeting = Meeting.new
		time = Time.new
		@current_date = time.day.to_s + '/' + time.month.to_s + '/' + time.year.to_s

		respond_to do |format|
			format.html # new.html.erb
			format.json { render json: @meeting }
		end
	end


	# POST /meetings
	# POST /meetings.json
	def create
		@meeting = Meeting.new(params[:meeting])
		@meeting.link_admin = UUIDTools::UUID.random_create().to_s

		array = Array.new

		if(params[:meeting][:topics] != '' && params[:meeting][:topics] != nil)
			array[0] = params[:meeting][:topics]
			i = 1
		else
			i = 0
		end

		params.each_key do |key|
			if ((key.starts_with? 'topics_') && params[key] != '' && params[key] != nil)
				array[i] = params[key]
				i = i + 1
			end
		end

		@meeting.topics = array

		respond_to do |format|
			if @meeting.save
				if true
					format.html { redirect_to meeting_path(@meeting.link_admin), notice: t("created_meeting", :default => "Meeting successfully created. Please check your email to continue the creation process.") }
				else
				  UserMailer.admin_email(@meeting.admin, "New meeting created", @meeting.link_admin).deliver
				end
				format.html { redirect_to root_path, notice: t("created_meeting", :default => "Meeting successfully created. Please check your email to continue the creation process.") }
				format.json { render json: @meeting, status: :created, location: @meeting }
			else
				format.html { render action: "new" }
				format.json { render json: @meeting.errors, status: :unprocessable_entity }
			end
		end
	end


	# GET /meetings/1/edit
	def edit
		@meeting = Meeting.find_by_link_admin(params[:id])

		respond_to do |format|
			format.html # edit.html.erb
			format.json { render json: @meeting }
		end
	end

	# PUT /meetings/1
	# PUT /meetings/1.json
	def update
		@meeting = Meeting.find_by_link_admin(params[:id])

    @meeting.topics = Array.new

    i = 0
		params.each_key do |key|
			if ((key.starts_with? 'topics_') && params[key] != '' && params[key] != nil)
				@meeting.topics[i] = params[key]
				i = i + 1
			end
    end


		respond_to do |format|
			if @meeting.update_attributes(params[:meeting])
				format.html { redirect_to meeting_path(@meeting.link_admin), notice: t("updated_meeting", :default => "Meeting successfully updated.") }
				format.json { head :ok }
      else
				format.html { render action: "edit" }
				format.json { render json: @meeting.errors, status: :unprocessable_entity }
			end
		end
	end

	# DELETE /meetings/1
	# DELETE /meetings/1.json
	def destroy
		@meeting = Meeting.find_by_link_admin(params[:id])
		@meeting.destroy

		respond_to do |format|
			format.html { redirect_to root_path }
			format.json { head :ok }
		end
	end
end
