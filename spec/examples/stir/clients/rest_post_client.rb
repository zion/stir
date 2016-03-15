module StirSpec
  class RestSpec < Stir::RestClient

    post(:new_post) { '/posts' }
    get(:all_posts) { '/posts' }
    get(:post) { '/posts/%{id}' }
    delete(:delete_post) { '/posts/%{id}' }
    put(:update_post) { '/posts/%{id}' }
    post(:new_profile) { '/profile' }
    get(:profile) { '/profile' }
    get(:posts_for) { '/posts?author=%{name}' }

    response(:post_author) { response.first['author'] }
    response(:profile_name) { response['name'] }
    response(:blah) { response.code }

  end
end