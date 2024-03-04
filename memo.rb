# frozen_string_literal: true

require 'sinatra'
require 'sinatra/reloader'
require 'pg'

helpers do
  def h(text)
    Rack::Utils.escape_html(text)
  end
end

def connect_db
  PG.connect(dbname: 'my_memo')
end

def memo_id
  params[:memo_id].to_i
end

def show_memos
  result = connect_db.exec_params('SELECT * FROM memos WHERE id = $1', [memo_id])
  @memo = result.first
end

get '/' do
  redirect '/memos'
end

get '/memos' do
  @memos = connect_db.exec('SELECT * FROM memos ORDER BY id')
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
  title = params['title']
  content = params['content']

  max_id = connect_db.exec('SELECT MAX(id) FROM memos').getvalue(0, 0).to_i
  new_id = max_id + 1
  connect_db.exec_params('INSERT INTO memos VALUES ($1, $2, $3)', [new_id, title, content])
  redirect '/'
end

patch '/memos/:memo_id' do
  title = params['title']
  content = params['content']

  @memo = connect_db.exec_params('UPDATE memos SET title = $1, content = $2 WHERE id = $3', [title, content, memo_id])
  redirect '/'
end

delete '/memos/:memo_id' do
  @memo = connect_db.exec_params('DELETE FROM memos WHERE id = $1', [memo_id])
  redirect '/'
end
