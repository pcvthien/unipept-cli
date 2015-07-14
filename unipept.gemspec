# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: unipept 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "unipept"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Toon Willems", "Bart Mesuere", "Tom Naessens"]
  s.date = "2015-07-14"
  s.description = "  Command line interface to the Unipept (http://unipept.ugent.be) web services\n  (pept2lca, taxa2lca, pept2taxa, pept2prot and taxonomy) and some utility commands for\n  handling proteins using the command line.\n"
  s.email = "unipept@ugent.be"
  s.executables = ["unipept", "prot2pept", "peptfilter", "uniprot"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".rubocop.yml",
    ".travis.yml",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "bin/peptfilter",
    "bin/prot2pept",
    "bin/unipept",
    "bin/uniprot",
    "lib/batch_iterator.rb",
    "lib/batch_order.rb",
    "lib/commands.rb",
    "lib/commands/peptfilter.rb",
    "lib/commands/prot2pept.rb",
    "lib/commands/unipept.rb",
    "lib/commands/unipept/api_runner.rb",
    "lib/commands/unipept/config.rb",
    "lib/commands/unipept/pept2lca.rb",
    "lib/commands/unipept/pept2prot.rb",
    "lib/commands/unipept/pept2taxa.rb",
    "lib/commands/unipept/taxa2lca.rb",
    "lib/commands/unipept/taxonomy.rb",
    "lib/commands/uniprot.rb",
    "lib/configuration.rb",
    "lib/formatters.rb",
    "lib/output_writer.rb",
    "lib/retryable_typhoeus.rb",
    "lib/server_message.rb",
    "lib/version.rb",
    "test/commands/test_peptfilter.rb",
    "test/commands/test_prot2pept.rb",
    "test/commands/test_unipept.rb",
    "test/commands/test_uniprot.rb",
    "test/commands/unipept/test_api_runner.rb",
    "test/commands/unipept/test_config.rb",
    "test/commands/unipept/test_pept2lca.rb",
    "test/commands/unipept/test_pept2prot.rb",
    "test/commands/unipept/test_pept2taxa.rb",
    "test/commands/unipept/test_taxa2lca.rb",
    "test/commands/unipept/test_taxonomy.rb",
    "test/helper.rb",
    "test/test_batch_iterator.rb",
    "test/test_batch_order.rb",
    "test/test_configuration.rb",
    "test/test_formatters.rb",
    "test/test_output_writer.rb",
    "test/test_retryable_typhoeus.rb",
    "test/test_server_message.rb",
    "unipept.gemspec"
  ]
  s.homepage = "https://github.com/unipept/unipept-cli/"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.1.11"
  s.summary = "Command line interface to Unipept web services."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<cri>, ["~> 2.7"])
      s.add_runtime_dependency(%q<typhoeus>, ["= 0.7.2"])
      s.add_development_dependency(%q<rake>, ["~> 10.4"])
      s.add_development_dependency(%q<minitest>, ["~> 5.7"])
      s.add_development_dependency(%q<rubocop>, ["~> 0.32"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0"])
      s.add_development_dependency(%q<coveralls>, [">= 0"])
    else
      s.add_dependency(%q<cri>, ["~> 2.7"])
      s.add_dependency(%q<typhoeus>, ["= 0.7.2"])
      s.add_dependency(%q<rake>, ["~> 10.4"])
      s.add_dependency(%q<minitest>, ["~> 5.7"])
      s.add_dependency(%q<rubocop>, ["~> 0.32"])
      s.add_dependency(%q<jeweler>, ["~> 2.0"])
      s.add_dependency(%q<coveralls>, [">= 0"])
    end
  else
    s.add_dependency(%q<cri>, ["~> 2.7"])
    s.add_dependency(%q<typhoeus>, ["= 0.7.2"])
    s.add_dependency(%q<rake>, ["~> 10.4"])
    s.add_dependency(%q<minitest>, ["~> 5.7"])
    s.add_dependency(%q<rubocop>, ["~> 0.32"])
    s.add_dependency(%q<jeweler>, ["~> 2.0"])
    s.add_dependency(%q<coveralls>, [">= 0"])
  end
end

