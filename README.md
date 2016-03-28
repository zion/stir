# STiR
***Service Testing in Ruby***

STiR is a lightweight framework for testing web services. It uses HTTParty under the
covers for REST services and Savon for SOAP services. The framework is designed to be
fairly agnostic to the type of service being tested.

## Installing STiR
Install the gem manually:
```ruby
$ gem install stir
```

Or add it to your Gemfile:
```ruby
gem 'stir'
```

You can require STiR for testing only REST services, only SOAP services, or both!:
```ruby
require 'stir/rest' # only installs rest components
require 'stir/soap' # only installs soap components
require 'stir/all' # installs both soap and rest components
```

## Using STiR
The main concept behind STiR is creating a lightweight *client* to consume and test a
web service. At a minimum, you need to define 2 things:

1. A *client* class that will give you the ability to interact with the web service and to model
the responses it returns.

2. A *YAML* file that contains configuration information about the service you are testing. In the
case of the REST service, the config file would include your base_uri for each environment and
endpoints you want to hit. For SOAP services, the config file points to the wsdl and other information. The yaml is designed to structure this information by *version* and *environment*.

## Directory Structure
You can place your STiR directory anywhere within your project. The STiR
directory must contain the following subdirectories:

```
stir
--clients
--config
```

## STiR Configuration
You must set *path*, *version*, and *environment* in your STiR configuration:
```ruby
Stir.configure do |config|
  config.path = File.join(path/to/your/stir/directory)
  config.environment = 'foo' # must match desired value from yaml
  config.version = 'bar' # must match desired value from yaml
end
```

#### Client and Config Association
STiR will automatically associate your client class file (ie, my_client.rb) with a config file of the same base name (ie, my_client.yml). There are times when you may want your client file and config file to not use the same name. For example, if you want multiple clients to share the same config. That is accomplished by passing the config file name to the client when calling the *config_file* method in the client file.

```ruby
module Client
  class RestClientName < Stir::RestClient
    self.config_file = File.join(Stir.path, 'config', 'my_config_name.yml')

    # client info goes here

  end
end
```

## Testing Services

### Rest Config Example
```ruby
v1: #version
    qa: #environment
      base_uri: 'http://localhost:9393'
    dev: #environment
      base_uri: 'http://localhost:9394'
```
### Rest Client Example
```ruby
module Client
  class RestClientName < Stir::RestClient

    get(:post) { '/posts/%{id}' } #defining the endpoint
    response(:foo) { response['bar'] } #defining item from response object

  end
end
```
### Using Rest Cleint
```ruby
client = Client::RestClientName.new
client.post { id: 15 }
client.foo # => value from 'bar' in reponse object
```
### Soap Config Example
```ruby
---
v1: #version
    qa: #environment
      wsdl: 'http://localhost:9393?wsdl'
    dev: #environment
      wsdl: 'http://localhost:9394?wsdl'
```
### Soap Client Example
```ruby
module Client
  class SoapClientName < Stir::SoapClient

    operation(:old_name, :new_name) #alias an operation name only works is you provide wsdl
    operation(:operation_name) #only required if you dont provide a wsdl
    response(:foo) { response['bar'] } #defining item from response object

  end
end
```
### Using Soap Client
```ruby
client = Client::SoapClientName
client.operation_name(message: {id: 15})
client.foo # => value from 'bar' in reponse object
```
