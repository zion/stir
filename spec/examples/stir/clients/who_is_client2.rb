module StirSpec
  class WhoIsClient2 < Stir::SoapClient

    operation(:get_who_is)

    response(:stupid_string_response) { response.body[:get_who_is_response][:get_who_is_result]  }

  end
end

