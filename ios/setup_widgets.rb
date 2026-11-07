require 'xcodeproj'

project_path = File.join(File.dirname(__FILE__), 'Runner.xcodeproj')
project = Xcodeproj::Project.open(project_path)

target_name = 'SakinaWidgets'
existing_target = project.targets.find { |t| t.name == target_name }

if existing_target
  puts "Target #{target_name} already exists in project."
else
  puts "Target #{target_name} not found. Creating..."

  runner_target = project.targets.find { |t| t.name == 'Runner' }
  unless runner_target
    abort "Error: Runner target not found!"
  end

  # Create App Extension Target
  widget_target = project.new_target(:app_extension, target_name, :ios, '15.0')

  # Create or find SakinaWidgets group
  sakina_group = project.main_group.find_subpath('SakinaWidgets', true)
  sakina_group.set_source_tree('<group>')
  sakina_group.set_path('SakinaWidgets')

  # Add files to group
  swift_file = sakina_group.find_file_by_path('SakinaWidgets.swift') || sakina_group.new_file('SakinaWidgets.swift')
  widget_target.add_file_references([swift_file])

  entitlements_file = sakina_group.find_file_by_path('SakinaWidgets.entitlements') || sakina_group.new_file('SakinaWidgets.entitlements')
  info_plist = sakina_group.find_file_by_path('Info.plist') || sakina_group.new_file('Info.plist')

  # Add Frameworks
  widget_target.add_system_framework('WidgetKit') rescue nil
  widget_target.add_system_framework('SwiftUI') rescue nil

  # Build settings for Widget Target
  bundle_id = 'com.sakina.islamic.4SH7N37L58.SakinaWidgets'
  team_id = '4SH7N37L58'

  widget_target.build_configurations.each do |config|
    config.build_settings['PRODUCT_BUNDLE_IDENTIFIER'] = bundle_id
    config.build_settings['INFOPLIST_FILE'] = 'SakinaWidgets/Info.plist'
    config.build_settings['CODE_SIGN_ENTITLEMENTS'] = 'SakinaWidgets/SakinaWidgets.entitlements'
    config.build_settings['DEVELOPMENT_TEAM'] = team_id
    config.build_settings['CODE_SIGN_STYLE'] = 'Manual'
    config.build_settings['PROVISIONING_PROFILE_SPECIFIER'] = ''
    config.build_settings['SWIFT_VERSION'] = '5.0'
    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    config.build_settings['TARGETED_DEVICE_FAMILY'] = '1'
    config.build_settings['GENERATE_INFOPLIST_FILE'] = 'NO'
    config.build_settings['CURRENT_PROJECT_VERSION'] = '$(FLUTTER_BUILD_NUMBER)'
    config.build_settings['MARKETING_VERSION'] = '$(FLUTTER_BUILD_NAME)'
    config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = config.name == 'Debug' ? '-Onone' : '-O'
  end

  # Configure Runner Target build settings for Entitlements & Team
  runner_target.build_configurations.each do |config|
    config.build_settings['CODE_SIGN_ENTITLEMENTS'] = 'Runner/Runner.entitlements'
    config.build_settings['DEVELOPMENT_TEAM'] = team_id
  end

  # Add Runner.entitlements to Runner group if not present
  runner_group = project.main_group.find_subpath('Runner', false)
  if runner_group && !runner_group.find_file_by_path('Runner.entitlements')
    runner_group.new_file('Runner.entitlements')
  end

  # Make Runner depend on SakinaWidgets
  runner_target.add_dependency(widget_target)

  # Embed Widget Extension into Runner.app/PlugIns
  embed_phase = runner_target.copy_files_build_phases.find { |p| p.name == 'Embed Foundation Extensions' || p.dst_subfolder_spec.to_s == '13' }
  unless embed_phase
    embed_phase = runner_target.new_copy_files_build_phase('Embed Foundation Extensions')
    embed_phase.dst_subfolder_spec = '13' # PlugIns
    embed_phase.dst_path = ''
  end
  embed_file = embed_phase.add_file_reference(widget_target.product_reference, true)
  embed_file.settings = { 'ATTRIBUTES' => ['RemoveHeadersOnCopy', 'CodeSignOnCopy'] }

  project.save
  puts "Successfully created and configured #{target_name} target!"
end
