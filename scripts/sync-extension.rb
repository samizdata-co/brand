#!/usr/bin/env ruby
# frozen_string_literal: true

require "fileutils"

root = File.expand_path("..", __dir__)
extension = File.join(root, "_extensions/samizdata")

logos = File.join(extension, "assets/logos")
FileUtils.rm_rf(logos)
FileUtils.mkdir_p(logos)
FileUtils.cp(File.join(root, "_brand.yml"), File.join(extension, "_brand.yml"))
FileUtils.cp(Dir[File.join(root, "assets/logos/*")], logos)

puts "Synchronized the Quarto extension from canonical brand files."
