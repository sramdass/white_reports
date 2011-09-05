# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{linecache}
  s.version = "0.46"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["R. Bernstein"]
  s.date = %q{2011-06-19}
  s.description = %q{LineCache is a module for reading and caching lines. This may be useful for
example in a debugger where the same lines are shown many times.
}
  s.email = %q{rockyb@rubyforge.net}
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = ["README", "lib/linecache.rb", "lib/tracelines.rb"]
  s.files = ["AUTHORS", "COPYING", "ChangeLog", "NEWS", "README", "Rakefile", "ext/trace_nums.c", "ext/trace_nums.h", "ext/extconf.rb", "lib/version.rb", "lib/tracelines.rb", "lib/linecache.rb", "test/parse-show.rb", "test/lnum-diag.rb", "test/rcov-bug.rb", "test/test-lnum.rb", "test/test-linecache.rb", "test/test-tracelines.rb", "test/data/if1.rb", "test/data/comments1.rb", "test/data/not-lit.rb", "test/data/begin2.rb", "test/data/block2.rb", "test/data/if6.rb", "test/data/end.rb", "test/data/case4.rb", "test/data/begin1.rb", "test/data/for1.rb", "test/data/match.rb", "test/data/match3a.rb", "test/data/class1.rb", "test/data/if3.rb", "test/data/if5.rb", "test/data/case1.rb", "test/data/def1.rb", "test/data/if7.rb", "test/data/block1.rb", "test/data/begin3.rb", "test/data/case3.rb", "test/data/case2.rb", "test/data/each1.rb", "test/data/if2.rb", "test/data/match3.rb", "test/data/if4.rb", "test/data/case5.rb", "test/short-file"]
  s.homepage = %q{http://rubyforge.org/projects/rocky-hacks/linecache}
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.rubyforge_project = %q{rocky-hacks}
  s.rubygems_version = %q{1.5.2}
  s.summary = %q{Read file with caching}
  s.test_files = ["test/parse-show.rb", "test/lnum-diag.rb", "test/rcov-bug.rb", "test/test-lnum.rb", "test/test-linecache.rb", "test/test-tracelines.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rbx-require-relative>, ["> 0.0.4"])
    else
      s.add_dependency(%q<rbx-require-relative>, ["> 0.0.4"])
    end
  else
    s.add_dependency(%q<rbx-require-relative>, ["> 0.0.4"])
  end
end
