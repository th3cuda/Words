class UrlsController < ApplicationController
  before_action :set_url, only: [:show, :edit, :update, :destroy]
  require 'open-uri'
  require 'CGI'

  # GET /urls
  # GET /urls.json
  def index
    @urls = Url.all
  end

  # GET /urls/1
  # GET /urls/1.json
  def show
  end

  # GET /urls/new
  def new
    @url = Url.new
  end

  # POST /urls
  # POST /urls.json
  def create
    @url = Url.new(url_params)

    respond_to do |format|
      if @url.save
        format.html { redirect_to @url, notice: 'Url was successfully created.' }
        format.json { render action: 'show', status: :created, location: @url }
        wordcount
      else
        format.html { render action: 'new' }
        format.json { render json: @url.errors, status: :unprocessable_entity }
      end
    end
  end

  def wordcount
    @app_url = CGI::escape(@url.to_s)

    # Parse the URI and retrieve it to a temporary file
    words_tmp_file = open(@app_url)

    # Parse the contents of the temporary file as HTML
    the_file = Nokogiri::HTML(words_tmp_file)
    
    h = Hash.new
    f = File.open(the_file, "r")
    f.each_line { |line|
      words = line.split
      words.each { |w|
        if h.has_key?(w)
          h[w] = h[w] + 1
        else
          h[w] = 1
        end
      }
    }

    # sort the hash by value, and then print it in this sorted order
    h.sort{|a,b| a[1]<=>b[1]}.each { |elem|
      puts "\"#{elem[0]}\" has #{elem[1]} occurrences"
    }

    render :text => html,:content_type => "text/plain"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_url
      @url = Url.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def url_params
      params.require(:url).permit(:url)
    end
end
