# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "argus-lyre"
  spec.version       = "0.1.0"
  spec.authors       = ["Argus McIntire"]
  spec.email         = ["argus.mcintire@protonmail.com"]

  spec.summary       = "Jekyll theme that plays nice with BS5 and podlove"

  spec.files         = `git ls-files -z`.split("\x0").select { |f| f.match(%r!^(assets|res|_layouts|_includes|_sass|LICENSE|README|_config\.yml)!i) }
end