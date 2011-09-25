# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{lazy_high_charts}
  s.version = "1.1.5"

  s.required_rubygems_version = Gem::Requirement.new("~> 1.3") if s.respond_to? :required_rubygems_version=
  s.authors = ["Miguel Michelson Martinez", "Deshi Xiao"]
  s.date = %q{2011-07-23}
  s.description = %q{    lazy_high_charts is a Rails 3.x gem for displaying Highcharts graphs.
}
  s.email = ["miguelmichelson@gmail.com", "xiaods@gmail.com"]
  s.extra_rdoc_files = ["README.md", "CHANGELOG.md"]
  s.files = [".gitignore", ".rspec", "CHANGELOG.md", "Gemfile", "MIT-LICENSE", "README.md", "Rakefile", "autotest/discover.rb", "init.rb", "lazy_high_charts.gemspec", "lib/generators/lazy_high_charts/install/install_generator.rb", "lib/lazy_high_charts.rb", "lib/lazy_high_charts/high_chart.rb", "lib/lazy_high_charts/layout_helper.rb", "lib/lazy_high_charts/railtie.rb", "lib/lazy_high_charts/version.rb", "rails/init.rb", "spec/high_chart_spec.rb", "spec/lazy_high_charts_spec.rb", "spec/spec_helper.rb"]
  s.homepage = %q{https://github.com/xiaods/lazy_high_charts}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{lazy higcharts gem for rails}

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<webrat>, ["~> 0.7"])
      s.add_development_dependency(%q<rspec>, ["~> 2.0"])
      s.add_development_dependency(%q<rails>, ["~> 3.0"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<webrat>, ["~> 0.7"])
      s.add_dependency(%q<rspec>, ["~> 2.0"])
      s.add_dependency(%q<rails>, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<webrat>, ["~> 0.7"])
    s.add_dependency(%q<rspec>, ["~> 2.0"])
    s.add_dependency(%q<rails>, ["~> 3.0"])
  end
end
