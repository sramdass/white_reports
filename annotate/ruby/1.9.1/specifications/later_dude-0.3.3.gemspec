# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{later_dude}
  s.version = "0.3.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Clemens Kofler"]
  s.date = %q{2011-09-05}
  s.description = %q{LaterDude is a small calendar helper plugin for Rails with i18n support.}
  s.email = %q{clemens@railway.at}
  s.extra_rdoc_files = ["README"]
  s.files = ["README"]
  s.homepage = %q{http://github.com/clemens/later_dude}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.7.2}
  s.summary = %q{Small calendar helper plugin for Rails with i18n support}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
