#!/usr/bin/env ruby
# frozen_string_literal: true

require "yaml"

ROOT = File.expand_path("..", __dir__)
WORKSPACE = File.expand_path("..", ROOT)
tokens = YAML.safe_load_file(File.join(ROOT, "datavis/tokens.yml"))
version = File.read(File.join(ROOT, "VERSION")).strip
graphics_css = File.read(File.join(WORKSPACE, "graphics/src/lib/theme/theme.css"))
graphics_ts = File.read(File.join(WORKSPACE, "graphics/src/lib/theme/colors.ts"))
r_colours = File.read(File.join(WORKSPACE, "samizplot/R/colours.R"))
r_theme = File.read(File.join(WORKSPACE, "samizplot/R/theme_samizdata.R"))
errors = []
errors << "graphics CSS does not record brand v#{version}" unless graphics_css.include?("brand v#{version}")
errors << "graphics canvas defaults do not record brand v#{version}" unless graphics_ts.include?("brand v#{version}")
errors << "samizplot does not record brand v#{version}" unless r_colours.include?("brand v#{version}")

normalize = ->(value) { value.to_s.strip.downcase }
css_values = ->(source) { source.scan(/(--[\w-]+)\s*:\s*([^;]+);/).to_h }
dark_start = graphics_css.index(".sz-theme[data-theme='dark']")
light_css = css_values.call(graphics_css[0...dark_start])
dark_css = css_values.call(graphics_css[dark_start..])

%w[foreground muted background surface surface-low border axis gridline baseline accent area-fill selection focus].each do |name|
  %w[light dark].each do |mode|
    expected = tokens.dig("color", name, mode)
    source = mode == "light" ? light_css : dark_css
    property = name == "focus" ? "--sz-focus-color" : "--sz-#{name}"
    actual = source[property] || light_css[property]
    errors << "graphics #{property} #{mode}: expected #{expected}, found #{actual.inspect}" unless normalize.call(actual) == normalize.call(expected)
  end
end

{
  "sans" => "--sz-font-sans",
  "display" => "--sz-font-display",
  "serif" => "--sz-font-serif"
}.each do |name, property|
  expected = tokens.dig("typography", name)
  actual = light_css[property]
  errors << "graphics #{property}: expected #{expected}, found #{actual.inspect}" unless actual&.downcase&.include?(expected.downcase)
end

%w[categorical sequential].each do |name|
  tokens.dig("palette", name).each_with_index do |expected, index|
    property = "--sz-#{name}-#{index + 1}"
    actual = light_css[property]
    errors << "graphics #{property}: expected #{expected}, found #{actual.inspect}" unless normalize.call(actual) == normalize.call(expected)
  end
end

diverging = tokens.dig("palette", "diverging")
{
  "negative" => diverging["negative"],
  "mid" => diverging.dig("midpoint", "light"),
  "positive" => diverging["positive"]
}.each do |name, expected|
  actual = light_css["--sz-diverging-#{name}"]
  errors << "graphics --sz-diverging-#{name}: expected #{expected}, found #{actual.inspect}" unless normalize.call(actual) == normalize.call(expected)
end
actual_dark_midpoint = dark_css["--sz-diverging-mid"]
expected_dark_midpoint = diverging.dig("midpoint", "dark")
errors << "graphics dark diverging midpoint: expected #{expected_dark_midpoint}, found #{actual_dark_midpoint.inspect}" unless normalize.call(actual_dark_midpoint) == normalize.call(expected_dark_midpoint)

canvas_scalars = {
  "accent" => tokens.dig("color", "accent", "light"),
  "background" => tokens.dig("color", "background", "light"),
  "foreground" => tokens.dig("color", "foreground", "light"),
  "muted" => tokens.dig("color", "muted", "light")
}
canvas_scalars.each do |name, expected|
  actual = graphics_ts[/\b#{name}:\s*'([^']+)'/, 1]
  errors << "canvas #{name}: expected #{expected}, found #{actual.inspect}" unless normalize.call(actual) == normalize.call(expected)
end

expected_palette_values = tokens.dig("palette", "categorical") + tokens.dig("palette", "sequential") + [
  diverging["negative"], diverging.dig("midpoint", "light"), diverging["positive"]
]
expected_palette_values.each do |value|
  errors << "graphics canvas defaults missing #{value}" unless graphics_ts.downcase.include?(value.downcase)
  errors << "samizplot palettes missing #{value}" unless r_colours.downcase.include?(value.downcase)
end

{
  "title_family" => tokens.dig("typography", "display"),
  "subtitle_family" => tokens.dig("typography", "sans"),
  "axis_text_family" => tokens.dig("typography", "sans"),
  "background_colour" => tokens.dig("color", "background", "light"),
  "title_colour" => tokens.dig("color", "foreground", "light"),
  "axis_text_colour" => tokens.dig("color", "muted", "light"),
  "axis_line_colour" => tokens.dig("color", "baseline", "light")
}.each do |name, expected|
  actual = r_theme[/\b#{Regexp.escape(name)}\s*=\s*"([^"]+)"/, 1]
  errors << "samizplot #{name}: expected #{expected}, found #{actual.inspect}" unless normalize.call(actual) == normalize.call(expected)
end

# ggplot2 uses eight-digit hex rather than CSS rgba() for the canonical gridline.
expected_grid = "#8A70764D"
actual_grid = r_theme[/\bgrid_colour\s*=\s*"([^"]+)"/, 1]
errors << "samizplot grid_colour: expected #{expected_grid}, found #{actual_grid.inspect}" unless normalize.call(actual_grid) == normalize.call(expected_grid)

if errors.empty?
  puts "SAMIZDATA visualization consumers are consistent."
else
  warn errors.join("\n")
  exit 1
end
