require 'money'
require 'crypto_math'
require 'crypto_math/root'
require 'require_all'

require "gera/engine"
require "gera/version"

require_rel 'banks'
require_rel 'builders'
require_rel 'repositories'

module GERA
  FACTORY_PATH = File.expand_path("../spec/factories", __dir__)
end

Gera = GERA
