module StirSpec
  class WhoIsClient < Stir::SoapClient

    operation(:get_who_is, :foo_operation)

    response(:stupid_string_response) { response[:get_who_is_response][:get_who_is_result]  }

  end
end

