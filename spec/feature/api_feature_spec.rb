describe 'API' do

  it 'scrapes the user\'s squad and returns details', type: :request do
    post getsquad_path(fplid: '2082739')
    expect(response.status).to eq(200)
    expect(response.content_type).to eq(Mime::JSON)
    # puts JSON.parse(response.body)
  end

end
