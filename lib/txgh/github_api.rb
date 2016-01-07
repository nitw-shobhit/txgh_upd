require 'octokit'

module Txgh
  class GitHubApi

    def initialize(login, oauth_token)
      @client = Octokit::Client.new(login: login, oauth_token: oauth_token)
    end

    def tags(repo)
      @client.tags(repo)
    end

    def tree(repo, sha)
      @client.tree(repo, sha, recursive: 1)
    end

    def blob(repo, sha)
      @client.blob(repo, sha)
    end

    def commit(repo, path, content, ref)
      blob = @client.create_blob repo, content
      master = @client.ref repo, ref
      base_commit = @client.commit repo, master[:object][:sha]
      tree = @client.create_tree repo,
        [{ path: path, mode: '100644', type: 'blob', sha: blob }],
        options = {base_tree: base_commit[:commit][:tree][:sha]}
      commit = @client.create_commit repo, "Updating translations for #{path} [skip ci]", tree[:sha],
        parents=master[:object][:sha]
      @client.update_ref repo, ref, commit[:sha]
    end

    def get_commit(repo, sha)
      @client.commit(repo, sha)
    end

  end
end
