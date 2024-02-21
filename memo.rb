# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'json'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def memos
  File.open('public/memos.json', 'r') { |file| JSON.parse(file.read) }
end

def write_memos(memos)
  File.open('public/memos.json', 'w') do |file|
    file.write(JSON.pretty_generate(memos))
  end
end

def show_memos
  @memo_id = params[:memo_id]
  @memo = memos[@memo_id]
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = memos
  erb :top
end

get '/memos/new' do
  erb :new
end

get '/memos/:memo_id' do
  show_memos
  erb :show
end

get '/memos/:memo_id/edit' do
  show_memos
  erb :edit
end

post '/memos/new' do
  memo = memos

  latest_key = memo.keys.map(&:to_i).max + 1
  memo[latest_key] = {
    'title' => params[:title],
    'content' => params[:content]
  }

  write_memos(memo)
  redirect '/'
end

patch '/memos/:memo_id' do
  memo = memos

  memo[params[:memo_id]] = {
    'title' => params[:title],
    'content' => params[:content]
  }

  write_memos(memo)
  redirect '/'
end

delete '/memos/:memo_id' do
  memo = memos

  memo.delete(params[:memo_id])
  write_memos(memo)
  redirect '/'
end
