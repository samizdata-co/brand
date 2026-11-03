#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

ROOT = File.expand_path("..", __dir__)
brand = YAML.safe_load_file(File.join(ROOT, "_brand.yml"))
datavis = YAML.safe_load_file(File.join(ROOT, "datavis/tokens.yml"))
css = File.read(File.join(ROOT, "css/tokens.css"))
version = File.read(File.join(ROOT, "VERSION")).strip

errors = []
errors << "VERSION must use semantic versioning" unless version.match?(/\A\d+\.\d+\.\d+\z/)
errors << "css/tokens.css header must identify v#{version}" unless css.start_with?("/* SAMIZDATA design tokens — v#{version}.")

def normalize(value)
  value.to_s.strip.downcase
end

def css_values(source)
  source.scan(/(--[\w-]+)\s*:\s*([^;]+);/).to_h
end

def luminance(hex)
  channels = hex.delete_prefix("#").scan(/../).map { |part| part.to_i(16) / 255.0 }
  linear = channels.map { |value| value <= 0.04045 ? value / 12.92 : ((value + 0.055) / 1.055)**2.4 }
  0.2126 * linear[0] + 0.7152 * linear[1] + 0.0722 * linear[2]
end

def contrast(first, second)
  light, dark = [luminance(first), luminance(second)].sort.reverse
  (light + 0.05) / (dark + 0.05)
end

css_tokens = css_values(css)
palette = brand.fetch("color").fetch("palette")
brand_color = ->(name, mode) { palette.fetch("#{name}-#{mode}") }

core = {
  "primary" => "--sz-color-primary",
  "primary-container" => "--sz-color-primary-container",
  "accent-text" => "--sz-color-accent-text",
  "accent-text-hover" => "--sz-color-accent-text-hover",
  "logo-mark" => "--sz-color-logo-mark",
  "surface" => "--sz-color-surface",
  "surface-low" => "--sz-color-surface-low",
  "surface-container" => "--sz-color-surface-container",
  "surface-high" => "--sz-color-surface-high",
  "surface-highest" => "--sz-color-surface-highest",
  "surface-lowest" => "--sz-color-surface-lowest",
  "surface-dim" => "--sz-color-surface-dim",
  "ink" => "--sz-color-ink",
  "muted" => "--sz-color-muted",
  "ink-soft" => "--sz-color-ink-soft",
  "outline" => "--sz-color-outline",
  "outline-ghost" => "--sz-color-outline-ghost",
  "border-soft" => "--sz-color-border-soft",
  "border-strong" => "--sz-color-border-strong",
  "border-accent" => "--sz-color-border-accent",
  "primary-glow" => "--sz-color-primary-glow",
  "destructive" => "--sz-color-destructive",
  "destructive-text" => "--sz-color-destructive-text",
  "on-primary" => "--sz-color-on-primary",
  "on-destructive" => "--sz-color-on-destructive"
}

# css_values retains the last declaration, which is the dark theme.
core.each do |brand_name, css_name|
  expected = brand_color.call(brand_name, "dark")
  actual = css_tokens[css_name]
  errors << "#{css_name}: expected dark #{expected}, found #{actual.inspect}" unless normalize(actual) == normalize(expected)
end

# Check light values against the declarations in the first token block.
light_block = css.split(%r{:root\[data-theme="dark"\]}, 2).first
light_tokens = css_values(light_block)
core.each do |brand_name, css_name|
  expected = brand_color.call(brand_name, "light")
  actual = light_tokens[css_name]
  errors << "#{css_name}: expected light #{expected}, found #{actual.inspect}" unless normalize(actual) == normalize(expected)
end

chart_core = {
  "foreground" => "ink",
  "muted" => "muted",
  "background" => "surface"
}
chart_core.each do |chart_name, brand_name|
  %w[light dark].each do |mode|
    expected = brand_color.call(brand_name, mode)
    actual = datavis.fetch("color").fetch(chart_name).fetch(mode)
    errors << "datavis color.#{chart_name}.#{mode}: expected #{expected}, found #{actual}" unless normalize(actual) == normalize(expected)
  end
end

chart_color_tokens = %w[foreground muted background surface surface-low axis gridline baseline accent area-fill selection]
chart_color_tokens.each do |name|
  expected_light = datavis.fetch("color").fetch(name).fetch("light")
  expected_dark = datavis.fetch("color").fetch(name).fetch("dark")
  css_name = "--sz-chart-#{name}"
  errors << "#{css_name}: expected light #{expected_light}, found #{light_tokens[css_name].inspect}" unless normalize(light_tokens[css_name]) == normalize(expected_light)
  errors << "#{css_name}: expected dark #{expected_dark}, found #{css_tokens[css_name].inspect}" unless normalize(css_tokens[css_name]) == normalize(expected_dark)
end

%w[categorical sequential].each do |palette_name|
  datavis.fetch("palette").fetch(palette_name).each_with_index do |expected, index|
    css_name = "--sz-chart-#{palette_name}-#{index + 1}"
    errors << "#{css_name}: expected #{expected}, found #{light_tokens[css_name].inspect}" unless normalize(light_tokens[css_name]) == normalize(expected)
  end
end

diverging = datavis.fetch("palette").fetch("diverging")
%w[negative positive].each do |name|
  css_name = "--sz-chart-diverging-#{name}"
  errors << "#{css_name}: expected #{diverging[name]}, found #{light_tokens[css_name].inspect}" unless normalize(light_tokens[css_name]) == normalize(diverging[name])
end
%w[light dark].each do |mode|
  source = mode == "light" ? light_tokens : css_tokens
  expected = diverging.fetch("midpoint").fetch(mode)
  actual = source["--sz-chart-diverging-midpoint"]
  errors << "--sz-chart-diverging-midpoint: expected #{mode} #{expected}, found #{actual.inspect}" unless normalize(actual) == normalize(expected)
end

expected_accent = brand_color.call("primary-container", "light")
actual_accent = datavis.fetch("color").fetch("accent").fetch("light")
errors << "datavis light accent: expected #{expected_accent}, found #{actual_accent}" unless normalize(actual_accent) == normalize(expected_accent)

datavis_focus = datavis.fetch("color").fetch("focus")
%w[light dark].each do |mode|
  expected_focus = brand_color.call("accent-text", mode)
  errors << "datavis #{mode} focus: expected #{expected_focus}, found #{datavis_focus[mode]}" unless normalize(datavis_focus[mode]) == normalize(expected_focus)
end

fonts = brand.fetch("typography").fetch("fonts").to_h { |font| [font.fetch("family"), font.fetch("weight")] }
errors << "Space Grotesk must provide weights 700 and 900" unless fonts["Space Grotesk"] == [700, 900]
errors << "Work Sans must provide weights 400 and 500" unless fonts["Work Sans"] == [400, 500]

surface_names = %w[surface surface-low surface-container surface-high surface-highest surface-lowest surface-dim]
text_names = %w[ink muted accent-text destructive-text]
%w[light dark].each do |mode|
  surfaces = surface_names.map { |name| brand_color.call(name, mode) }
  text_names.each do |name|
    minimum = surfaces.map { |surface| contrast(brand_color.call(name, mode), surface) }.min
    errors << "#{name} #{mode} contrast is #{minimum.round(2)}:1; expected at least 4.5:1" if minimum < 4.5
  end
end

fill_pairs = [
  ["primary container light", brand_color.call("on-primary", "light"), brand_color.call("primary-container", "light")],
  ["primary container dark", brand_color.call("on-primary", "dark"), brand_color.call("primary-container", "dark")],
  ["destructive light", brand_color.call("on-destructive", "light"), brand_color.call("destructive", "light")],
  ["destructive dark", brand_color.call("on-destructive", "dark"), brand_color.call("destructive", "dark")]
]
fill_pairs.each do |name, foreground, background|
  score = contrast(foreground, background)
  errors << "#{name} contrast is #{score.round(2)}:1; expected at least 4.5:1" if score < 4.5
end

# The mozaic theme in datavis/mozaic/ is a distribution artifact of datavis/tokens.yml.
mozaic = File.read(File.join(ROOT, "datavis/mozaic/theme.ts"))
errors << "datavis/mozaic/theme.ts header must identify brand v#{version}" unless mozaic.include?("brand v#{version}.")
mozaic_token = ->(name) { mozaic[/'--mz-#{name}':\s*'([^']+)'/, 1] }
{
  "color-text" => datavis.dig("color", "foreground", "light"),
  "color-muted" => datavis.dig("color", "muted", "light"),
  "color-bg" => datavis.dig("color", "background", "light"),
  "color-axis" => datavis.dig("color", "axis", "light"),
  "color-grid" => datavis.dig("color", "gridline", "light"),
  "color-accent" => datavis.dig("color", "accent", "light"),
  "color-tooltip-bg" => datavis.dig("tooltip", "surface", "light"),
  "size-axis" => datavis.dig("typography", "axis-size"),
  "weight-strong" => datavis.dig("typography", "strong-weight").to_s,
  "grid-dash" => datavis.dig("line", "gridline-dash")
}.each do |name, expected|
  actual = mozaic_token.call(name)
  errors << "mozaic --mz-#{name}: expected #{expected}, found #{actual.inspect}" unless normalize(actual) == normalize(expected)
end
mozaic_list = ->(name) { mozaic[/#{name}:\s*\[([^\]]+)\]/, 1].to_s.scan(/'([^']+)'/).flatten.map { |value| normalize(value) } }
%w[categorical sequential].each do |name|
  expected = datavis.dig("palette", name).map { |value| normalize(value) }
  errors << "mozaic #{name} palette: expected #{expected}, found #{mozaic_list.call(name)}" unless mozaic_list.call(name) == expected
end
mozaic_diverging = [diverging["negative"], diverging.dig("midpoint", "light"), diverging["positive"]].map { |value| normalize(value) }
errors << "mozaic diverging palette: expected #{mozaic_diverging}, found #{mozaic_list.call('diverging')}" unless mozaic_list.call("diverging") == mozaic_diverging
%w[display sans].each do |role|
  family = datavis.dig("typography", role)
  errors << "mozaic theme does not use #{family}" unless mozaic.include?("'#{family}'")
end
mark = File.read(File.join(ROOT, "assets/logos/mark.svg"))
mozaic_mark = File.read(File.join(ROOT, "datavis/mozaic/logo.ts"))
mark.scan(/<rect [^>]+>/).each do |rect|
  errors << "mozaic logo is missing #{rect}; copy it from assets/logos/mark.svg" unless mozaic_mark.include?(rect)
end

extension = File.join(ROOT, "_extensions/samizdata")
extension_brand = File.join(extension, "_brand.yml")
errors << "Quarto extension _brand.yml is stale; run scripts/sync-extension.rb" unless File.exist?(extension_brand) && File.binread(extension_brand) == File.binread(File.join(ROOT, "_brand.yml"))

source_logos = Dir[File.join(ROOT, "assets/logos/*")].to_h { |path| [File.basename(path), File.binread(path)] }
extension_logos = Dir[File.join(extension, "assets/logos/*")].to_h { |path| [File.basename(path), File.binread(path)] }
errors << "Quarto extension logos are stale; run scripts/sync-extension.rb" unless source_logos == extension_logos

extension_meta = YAML.safe_load_file(File.join(extension, "_extension.yml"))
errors << "Quarto extension version must match VERSION #{version}" unless extension_meta["version"].to_s == version
errors << "Quarto extension must contribute _brand.yml" unless extension_meta.dig("contributes", "metadata", "project", "brand") == "_brand.yml"
errors << "Quarto extension must require Quarto >=1.8.20" unless extension_meta["quarto-required"] == ">=1.8.20"

if errors.empty?
  puts "SAMIZDATA tokens are consistent."
else
  warn errors.join("\n")
  exit 1
end
