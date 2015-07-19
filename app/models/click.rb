class Click < Sequel::Model
  many_to_one :article
end
