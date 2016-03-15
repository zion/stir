module StirSpec
  class AnimalClient < Stir::RestClient
    get(:animals) { '/animals'}
  end
end