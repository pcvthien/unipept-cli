# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: unipept 0.5.7 ruby lib

Gem::Specification.new do |s|
  s.name = "unipept"
  s.version = "0.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Toon Willems", "Bart Mesuere", "Tom Naessens"]
  s.date = "2015-04-08"
  s.description = "Command line interface to Unipept web services."
  s.email = "unipept@ugent.be"
  s.executables = ["unipept", "prot2pept", "peptfilter", "uniprot"]
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "Rakefile",
    "VERSION",
    "bin/peptfilter",
    "bin/prot2pept",
    "bin/unipept",
    "bin/uniprot",
    "lib/unipept.rb",
    "lib/unipept/batch_order.rb",
    "lib/unipept/commands.rb",
    "lib/unipept/commands/api_runner.rb",
    "lib/unipept/commands/pept2lca.rb",
    "lib/unipept/commands/pept2prot.rb",
    "lib/unipept/commands/pept2taxa.rb",
    "lib/unipept/commands/taxa2lca.rb",
    "lib/unipept/commands/taxonomy.rb",
    "lib/unipept/configuration.rb",
    "lib/unipept/formatters.rb",
    "lib/unipept/version.rb",
    "test/helper.rb",
    "test/test_unipept.rb",
    "unipept.gemspec"
  ]
  s.homepage = "https://github.com/unipept/unipept/"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Command line interface to Unipept web services."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, ["~> 3.5"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.8"])
      s.add_runtime_dependency(%q<typhoeus>, ["~> 0.6"])
      s.add_runtime_dependency(%q<cri>, ["~> 2.6"])
    else
      s.add_dependency(%q<shoulda>, ["~> 3.5"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 2.0"])
      s.add_dependency(%q<simplecov>, ["~> 0.8"])
      s.add_dependency(%q<typhoeus>, ["~> 0.6"])
      s.add_dependency(%q<cri>, ["~> 2.6"])
    end
  else
    s.add_dependency(%q<shoulda>, ["~> 3.5"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 2.0"])
    s.add_dependency(%q<simplecov>, ["~> 0.8"])
    s.add_dependency(%q<typhoeus>, ["~> 0.6"])
    s.add_dependency(%q<cri>, ["~> 2.6"])
  end
end

