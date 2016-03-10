$dev_env = 'develop'

require 'sinatra'
require_relative 'Db.rb'

require_relative 'configure.rb'


enable :sessions

before do
  @message = session[:message]
  session[:message] = ""
end

get '/' do
  @list = $db.show
  
  erb :home
end


get '/test' do
  @data = $db.date
  
  erb :test
end

post '/delete' do
  # sinatraってdeleteサポートされてなかったっけ？
  key = params[:key]
  res = $db.search key
  unless $db.delete(key)
    session[:message] = "(#{key}, #{res})の削除に失敗しました"
  else
    session[:message] = "{#{key}, #{res})を削除しました"
  end
    
  redirect '/'
end

post '/create' do
  unless $db.insert(params[:key], params[:res])
    session[:message] = "キー「#{params[:key]}」は既に登録されています"
  else
    session[:message] = "登録が完了しました"
  end
  
  redirect  '/'
end

