require 'sinatra'

get "/" do
  slim :form
end

post '/upload' do
	content_type :json
  tempfile = Tempfile.new
  upload_realname = params[:file][:filename]
  upload_tempfile = params[:file][:tempfile]
  `./mdb2sql.sh #{upload_tempfile.path} #{tempfile.path}`
  '{"export_db":"/download?tempfile='+tempfile.path+'&realname='+upload_realname+'"}'
end

get "/download" do
  send_file params[:tempfile], :filename => params[:realname]+".sql", :type => "application/octet-stream", :disposition => :attachment
end

run Sinatra::Application
