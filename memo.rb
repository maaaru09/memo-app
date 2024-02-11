# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

MEMO_FILE = 'public/memos.json'

def memos(memo_file)
  File.open(memo_file, 'r') { |file| JSON.parse(file.read) }
end

def memo_write(memo_file, memos)
  File.open(memo_file, 'w') do |file|
    file.write(JSON.pretty_generate(memos))
  end
end

get '/' do
  redirect '/memos'
end

get '/memos/?' do
  @memos = memos(MEMO_FILE)
  erb :top
end

get '/memos/new' do
  erb :new
end

get '/memos/:memo_id' do
  @memo_id = params[:memo_id]
  @memos = memos(MEMO_FILE)
  erb :show
end

get '/memos/:memo_id/edit' do
  @memo_id = params[:memo_id]
  @memos = memos(MEMO_FILE)
  erb :edit
end

post '/memos/new' do
  memos = memos(MEMO_FILE)

  latest_key = memos.keys.map(&:to_i).max + 1
  memos[latest_key] = {
    'title' => params[:title],
    'content' => params[:content]
  }

  memo_write(MEMO_FILE, memos)
  redirect '/'
end

patch '/memos/:memo_id' do
  memo_id = params[:memo_id]
  memos = memos(MEMO_FILE)

  memos[memo_id] = {
    'title' => params[:title],
    'content' => params[:content]
  }

  memo_write(MEMO_FILE, memos)
  redirect '/'
end

delete '/memos/:memo_id' do
  memo_id = params[:memo_id]
  memos = memos(MEMO_FILE)

  memos.delete(memo_id)
  memo_write(MEMO_FILE, memos)
  redirect '/'
end
