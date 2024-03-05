# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

CONNECT_DB = PG.connect(dbname: 'my_memo')

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def show_memo
  memo_id = params[:memo_id].to_i
  CONNECT_DB.exec_params('SELECT * FROM memos WHERE id = $1', [memo_id])
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = CONNECT_DB.exec('SELECT * FROM memos ORDER BY id')
  erb :top
end

get '/memos/new' do
  erb :new
end

get '/memos/:memo_id' do
  @memo = show_memo.first
  erb :show
end

get '/memos/:memo_id/edit' do
  @memo = show_memo.first
  erb :edit
end

post '/memos/new' do
  title = params['title']
  content = params['content']

  CONNECT_DB.exec_params('INSERT INTO memos (title, content) VALUES ($1, $2)', [title, content])
  redirect '/'
end

patch '/memos/:memo_id' do
  title = params['title']
  content = params['content']
  memo_id = params[:memo_id].to_i

  @memo = CONNECT_DB.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [title, content, memo_id])
  redirect '/'
end

delete '/memos/:memo_id' do
  memo_id = params[:memo_id].to_i

  @memo = CONNECT_DB.exec_params('DELETE FROM memos WHERE id = $1', [memo_id])
  redirect '/'
end
