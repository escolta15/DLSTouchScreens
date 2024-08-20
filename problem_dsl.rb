require 'erb'
require_relative 'angular_project_dsl.rb'
require_relative 'touch_screen_dsl.rb'
require_relative 'touch_screen_z100_dsl.rb'
require_relative 'touch_screen_z70_dsl.rb'
require_relative 'touch_screen_z50_dsl.rb'
require_relative 'touch_screen_z41_com_dsl.rb'
require_relative 'touch_screen_z41_pro_dsl.rb'
require_relative 'touch_screen_z41_lite_dsl.rb'
require_relative 'touch_screen_z40_dsl.rb'
require_relative 'touch_screen_z35_dsl.rb'
require_relative 'touch_screen_z28_dsl.rb'

# A continuación, aparecen los distintos productos. Se pueden poner los que se quieran

z100 = TouchScreenZ100.new
z100.name = 'z100'
z100.set_color('silver')
z100.set_license('Smartphone Control')

=begin
z70 = TouchScreenZ70.new
z70.name = 'z70'
z70.set_color('anthracite black')
z70.set_license('ZenVoice')

z50 = TouchScreenZ50.new
z50.name = 'z50'
z50.set_color('matte white')

z41Com = TouchScreenZ41Com.new
z41Com.name = 'z41Com'
z41Com.set_color('glossy white')

z41Pro = TouchScreenZ41Pro.new
z41Pro.name = 'z41Pro'
z41Pro.set_color('silver')

z41Lite = TouchScreenZ41Lite.new
z41Lite.name = 'z41Lite'
z41Lite.set_color('silver')

z40 = TouchScreenZ40.new
z40.name = 'z40'
z40.set_color('silver')

z35 = TouchScreenZ35.new
z35.name = 'z35'
z35.set_color('silver')

z28 = TouchScreenZ28.new
z28.name = 'z28'
z28.set_color('silver')
=end

touch_screens = [z100]

for touch_screen in touch_screens
  project = AngularProjectDSL.new(touch_screen)
  project.package('@angular/material', '13.3.9')
  project.component("Page")
  project.component("Box")
  project.generate
end
