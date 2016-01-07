require_relative 'spec_helper'
require_relative 'assets/samplepo'
require_relative 'assets/samplecommit'

RSpec.describe Txgh do
  it 'has some auth' do
    auth = Txgh::Authentication.new
    expect(auth.can_load?).to eq(true)
    auth.show_values
  end
  it 'can connect to Transifex API' do
    puts ENV['TX_API_USERNAME'] +'||'+ENV['TX_API_PASSWORD']
    conn = Txgh::TransifexApi.instance(ENV['TX_API_USERNAME'], ENV['TX_API_PASSWORD'])

    lang_map = nil
    project_slug = 'txgh-test-1'
    resource_slug = 'samplepo'
    file_filter = 'translations/<lang>/sample.po'
    source_file = 'sample.po'
    source_lang = 'en'
    type = 'PO'
    r = Txgh::TxResource.new(project_slug, resource_slug, type, source_lang, source_file, lang_map, file_filter)

    expect(conn.resource_exists?(r)).to eq(true)
    c = conn.download(r,'en')
    #    expect(c).to eq(SAMPLEPO)
    ur = conn.update(r,c)
    er = {"strings_added"=>0, "strings_updated"=>0, "strings_delete"=>0, "redirect"=>"/test-organization-4/txgh-test-1/samplepo/"}
    expect(ur).to eq(er)
  end

  it 'can create a Transifex Resource' do
    # From tx.config
=begin
[txgh-test-1.samplepo]
file_filter = translations/<lang>/sample.po
source_file = sample.po
source_lang = en
type = PO
=end
    lang_map = nil
    project_slug = 'txgh-test-1'
    resource_slug = 'samplepo'
    file_filter = 'translations/<lang>/sample.po'
    source_file = 'sample.po'
    source_lang = 'en'
    type = 'PO'
    r = Txgh::TxResource.new(project_slug, resource_slug, type, source_lang, source_file, lang_map, file_filter)
    expect(r.project_slug).to eq('txgh-test-1')
    expect(r.resource_slug).to eq('samplepo')
    expect(r.type).to eq('PO')
    expect(r.source_lang).to eq('en')
    expect(r.source_file).to eq('sample.po')
    expect(r.lang_map('en')).to eq('en')
    expect(r.translation_path('en')).to eq('translations/en/sample.po')
  end

  it 'can create a Key Manager' do
    txenv = ENV.to_h
    ghenv = ENV.to_h
    kmgh = Txgh::KeyManager.github_repo_config(txenv)
    expect(kmgh.size).to be >  0
    kmtx = Txgh::KeyManager.transifex_project_config(ghenv)
    expect(kmtx.size).to be >  0
  end

  it 'can create a Transifex project' do
    txenv = Txgh::KeyManager.transifex_project_config(ENV.to_h)
    lang_map = nil
    project_slug = 'txgh-test-1'
    resource_slug = 'samplepo'
    file_filter = 'translations/<lang>/sample.po'
    source_file = 'sample.po'
    source_lang = 'en'
    type = 'PO'
    p = Txgh::TxProject.new(project_slug,txenv)
    r = Txgh::TxResource.new(project_slug, resource_slug, type, source_lang, source_file, lang_map, file_filter)
    conn = p.api
    expect(conn.resource_exists?(r)).to eq(true)
  end

  it 'can create a Github API' do
    kmgh = Txgh::KeyManager.github_repo_config(ENV.to_h)
    a = Txgh::GitHubApi.new(kmgh['api_username'], kmgh['api_token'])
    r = 'matthewjackowski/txgh-test-resources'
    s = '984282845cf54935e4e7d27e3091d65b4f95e037'
    ONETAG = [{:name=>"v1.0.0", :zipball_url=>"https://api.github.com/repos/matthewjackowski/txgh-test-resources/zipball/v1.0.0", :tarball_url=>"https://api.github.com/repos/matthewjackowski/txgh-test-resources/tarball/v1.0.0", :commit=>{:sha=>"984282845cf54935e4e7d27e3091d65b4f95e037", :url=>"https://api.github.com/repos/matthewjackowski/txgh-test-resources/commits/984282845cf54935e4e7d27e3091d65b4f95e037"}}]
    c = a.get_commit(r,s).inspect
    expect(c).to eq(SAMPLECOMMIT)
    tags = a.tags(r)
    expect(tags.select{|h| h[:name] == "v1.0.0"}).not_to be_empty
  end

  it 'can create a Github Repository' do
    kmgh = Txgh::KeyManager.github_repo_config(ENV.to_h)
    kmtx = Txgh::KeyManager.transifex_project_config(ENV.to_h)
    github_repository_name = 'matthewjackowski/txgh-test-resources'
    g = Txgh::GhRepository.new(github_repository_name, kmgh, kmtx )
    p = g.transifex_project
    lang_map = nil
    project_slug = 'txgh-test-1'
    resource_slug = 'samplepo'
    file_filter = 'translations/<lang>/sample.po'
    source_file = 'sample.po'
    source_lang = 'en'
    type = 'PO'
    r = Txgh::TxResource.new(project_slug, resource_slug, type, source_lang, source_file, lang_map, file_filter)
    conn = p.api
    expect(conn.resource_exists?(r)).to eq(true)
    print g.branch
  end


  it 'has a version number' do
    expect(Txgh::VERSION).not_to be nil
  end

  it 'does something useful' do
    expect(true).to eq(true)
  end
end
