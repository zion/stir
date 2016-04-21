# STiR
***Service Testing in Ruby***

STiR is an opinionated framework for testing web services.  Using the same concepts as a page-object framework, STiR aims to be fairly agnostic to the type of service being tested.  It uses HTTParty under the covers for REST services and Savon for SOAP services. 

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
require 'stir/rest' # only requires rest components
require 'stir/soap' # only requires soap components
require 'stir/all' # requires both soap and rest components
```

## Getting Started

## Directory Structure
STiR has certain conventions.  One such convention is the directory structure.  You can place your STiR directory anywhere within your project but the STiR
directory must contain the following subdirectories:

```
stir (this can be named anything and located anywhere)
--clients
--config
```

The main concept behind STiR is to create a central place to define service objects (endpoints for rest, operations for soap), similar to how a page-object framework centralizes where web elements are defined.  As you might have guessed, client definitions go in the ```clients``` directory and config information goes in the ```config``` directory. 

## STiR Configuration
To tell STiR where to find your clients and configs you must configure STiR.  Path, Environment, and Version are all required fields.

```ruby
Stir.configure do |config|
  config.path = '/path/to/your/parent/stir/directory'
  config.environment = 'dev' # must match desired value from yaml
  config.version = 'v1' # must match desired value from yaml
end
```

# Usage
#### Define a REST configuration

```yaml
# ~/project_dir/stir/config/sample.yml
v1:
  dev:
    base_uri: http://localhost:3000
```

#### Define a REST client

```ruby
# ~/project_dir/stir/client/sample.rb
class Sample < Stir::RestClient
  get(:post_by_id) { '/posts/%{id}' } #defining the endpoint
  response(:post_name) { response['postName'] } #defining item from response object
end
```

STiR will automatically find the correct config file for your client.  For every client, STiR will look for a config file with the same name as the class name of the client.  In the example above, STiR will look for a config file named ```sample.yml``` inside the config directory

### Using STiR in REST Tests
```ruby
describe 'Posts' do
  let(:sample) { Sample.new }
  describe 'get post by id' do
    it 'should return the correct post' do
      sample.post_by_id(id: 15)
      expect(sample.post_name).to eql 'Sample Post Name'
    end
  end
end
```

### Define a SOAP configuration
```ruby
---
# ~/project_dir/stir/config/soap_sample.yml
v1: #version
    qa: #environment
      wsdl: 'http://localhost:9393?wsdl'
    dev: #environment
      wsdl: 'http://localhost:9394?wsdl'
```

### Define a SOAP client
```ruby

class SoapSample < Stir::SoapClient
  operation(:old_name, :new_name) #alias an operation name only works is you provide wsdl
  operation(:user_id_by_name) #only required if you dont provide a wsdl
  response(:id) { response['id'] } #defining item from response object
end
```

### Using STiR in SOAP Tests
```ruby
describe 'Users' do
  let(:sample) { SoapSample.new }
  describe 'get user id by name' do
    it 'should return the correct id' do
      sample.user_id_by_name( message: { "user_name" => "test_user" } )
      expect(sample.id).to eql '259'
    end
  end
end
```