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
require 'stir/rest' # only installs rest componants
require 'stir/soap' # only installs soap componants
require 'stir/all' # installs both soap and rest componants
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

## Testing REST Services

### REST Config
STiR uses a YAML file for defining data about the service you are testing. For REST services,
this includes the *base_uri* for each environment you are testing as well as other configuration
information.

```ruby
---
v1: #version
    qa: #environment
      base_uri: 'http://localhost:9393'
    dev: #environment
      base_uri: 'http://localhost:9394'
```

#### REST Config Default Options
For each environment you define you can set the following default options:
```ruby
basic_auth:
digest_auth:
format:
timeout:
no_follow:
maintain_method_across_redirects:
ssl_ca_file:
ssl_ca_path:
body:
http_proxyaddr:
http_proxyport:
http_proxyuser:
http_proxypass:
limit:
query:
local_host:
local_port:
base_uri:
debug_output:
headers:
connection_adapter:
pem:
query_string_normalizer:
```

See the HTTParty documentation for more information on these optional settings.

http://www.rubydoc.info/github/jnunemaker/httparty

### REST Clients
To create a STiR REST *client*, create a new class in your clients directory. Your client
class extends the **Stir::RestClient** class, which allows you to define endpoints
as well as methods for the handling & modeling of the responses you receive from the service.

```ruby
module Client
  class RestClientName < Stir::RestClient

    # client info goes here

  end
end
```

#### Defining REST Endpoints
The Base URI for a REST service is defined in the config. The rest of the endpoint is defined in the client class. You define the endpoint by passing a block with the endpoint information to a method named after the verb, and providing a name for the endpoint as a symbol.
```ruby
verb(:symbol) { '/endpoint'  }
```

For example, if you had an endpoint that is "https:/localhost/posts" for **get** requests, you would define it as follows:
```ruby
    get(:all_posts) { '/posts' }
```

You would then be able to call the newly defined **all_posts** method against the client class.

Passing in args to the endpoint are done by passing a hash of the args to the endpoint method. The endpoint is defined using the **%{arg}** format. For example, if you have to pass in **ID** to the endpoint the method call, and endpoint would be:
```ruby
get(:post) { '/posts/%{id}' } #defining the endpoint
```
```ruby
client_class.post { id: "id_value" } #calling the post method
```

You can pass in multiple args the same way:
```ruby
get(:posts_for) { '/posts/%{first_arg}/%{second_arg}' } #defining the endpoint
```
```ruby
client_class.post { first_arg: "foo", second_arg: "bar" } #calling the post method
```


#### Defining REST Reponse Objects
- I dont like calling them objects. Is there a better word?

## Testing SOAP Services

### SOAP Config
STiR uses a YAML file for defining data about the service you are testing. For SOAP services,
this includes the *wsdl* for each environment you are testing as well as other configuration
information.

```ruby
---
v1: #version
    qa: #environment
      wsdl: 'http://localhost:9393?wsdl'
    dev: #environment
      wsdl: 'http://localhost:9394?wsdl'
```

#### SOAP Config Default Options
For each environment you define you can set the following default options:
```ruby
wsdl: # minimum required option
endpoint:
namespace:
proxy:
open_timeout:
read_timeout:
soap_header:
encoding:
basic_auth:
digest_auth:
log:
log_level:
pretty_print_xml:
wsse_auth:
```

See the Savon documentation for more information on these optional settings.

http://savonrb.com/version2/

### SOAP Clients
To create a STiR SOAP *client*, create a new class in your clients directory. Your client
class extends the **Stir::SoapClient** class, which allows you to define operations
as well as methods for the handling & modeling of the responses you receive from the service.

```ruby
module Client
  class SoapClientName < Stir::SoapClient

    # client info goes here

  end
end
```
#### Defining SOAP Operations

If a wsdl is provided, perations are automatically defined as methods in the client class, there is no need to do that manually. However, if a wsdl is not provided, then operations must be defined manually in the client class using the **operation** method.

```ruby
operation(:valid_operation_name) # where valid_operation_name matches an operation
```

If you provide a wsdl, and the operations are automatically defined as methods, you can use the **operation** method to alias an operation to a new name from inside the client class.

```ruby
operation(:old_operation_name, :new_operation_name)
```

Operations are then calles as methods on the client class, and can be given the same args that a normal savon **call* method takes.

```ruby
client = SoapClientName.new
client.operation_name(message: { foo: "bar" })
```

#### Defining SOAP Response Objects

