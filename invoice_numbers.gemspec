lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'invoice_numbers/version'

Gem::Specification.new do |spec|
  spec.name          = 'invoice_numbers'
  spec.version       = InvoiceNumbers::VERSION
  spec.authors       = [ 'Rob Scheepmaker']
  spec.email         = ['rob@rscheepmaker.nl']

  spec.description   = 'Create sequences of uninterrupted invoice numbers'
  spec.summary       = 'Create sequences of uninterrupted invoice numbers'
  spec.homepage      = 'https://github.com/bookingexperts/invoice_numbers'
  spec.license       = 'MIT'
  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test)/})
  end

  spec.require_paths = ['lib']
  spec.extra_rdoc_files = [ 'README.rdoc' ]

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.10'
  spec.add_development_dependency 'sqlite3', '~> 1.3'

  spec.add_development_dependency 'rails', '~> 4.2'
  spec.add_development_dependency 'activerecord', '>= 0'
  spec.add_development_dependency 'mongoid', '>= 0'
  spec.add_development_dependency 'database_cleaner', '>= 0'
end
