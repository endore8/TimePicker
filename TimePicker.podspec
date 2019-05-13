Pod::Spec.new do |spec|
  spec.name = "TimePicker"
  spec.version = "0.0.5"
  spec.summary = "Better time picker for iOS"
  spec.homepage = "https://github.com/Endore8/TimePicker"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Oleh Stasula" => 'endore8@gmail.com' }

  spec.platform = :ios, "10.0"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/Endore8/TimePicker.git", tag: "v#{spec.version}", submodules: true }
  spec.source_files = "TimePicker/**/*.{h,swift}"
end
