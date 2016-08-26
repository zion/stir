module StirSpec
  class WhoIsClient < Stir::SoapClient
    self.custom_config = { config_file: File.join(Stir.path, 'config', 'becky_with_the_good_hair.yml'),
                           environment: "prod",
                           version: 99 }

    operation(:get_who_is, :foo_operation)

    response(:stupid_string_response) { response.body[:get_who_is_response][:get_who_is_result]  }

  end
end

