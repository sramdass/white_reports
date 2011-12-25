# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{dynamic_attributes}
  s.version = "1.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Reinier de Lange"]
  s.date = %q{2010-11-21}
  s.description = %q{dynamic_attributes is a gem that lets you dynamically specify attributes on ActiveRecord models, which will be serialized and
deserialized to a given text column. Dynamic attributes can be defined by simply setting an attribute or by passing them on create or update.}
  s.email = %q{r.j.delange@nedforce.nl}
  s.extra_rdoc_files = ["LICENSE", "README.rdoc"]
  s.files = ["LICENSE", "README.rdoc"]
  s.homepage = %q{http://github.com/moiristo/dynamic_attributes}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{dynamic_attributes is a gem that lets you dynamically specify attributes on ActiveRecord models, which will be serialized and deserialized to a given text column.}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
