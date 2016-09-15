module StirSpec
  class RestSpec < Stir::RestClient

    # self.config_file = File.join(Stir.path, 'config', 'hello.yml')
    # self.config = {config_file: File.join(Stir.path, 'config', 'becky_with_the_good_hair.yml'),
    #                environment: "prod",
    #                version: 99}


    post(:new_post) { '/posts' }
    get(:all_posts) { '/posts' }
    get(:post) { '/posts/%{id}' }
    delete(:delete_post) { '/posts/%{id}' }
    put(:update_post) { '/posts/%{id}' }
    post(:new_profile) { '/profile' }
    get(:profile) { '/profile' }
    get(:posts_for) { '/posts?author=%{name}' }
    get(:two_param_test) { '/%{endpoint}/%{id}' }

    response(:post_author) { response.first['author'] }
    response(:profile_name) { response['name'] }
    response(:blah) { response.code }

  end
end