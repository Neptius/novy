defmodule NovyWeb.Layouts.SwiftUI do
  use NovyNative, [:layout, format: :swiftui]

  embed_templates "layouts_swiftui/*"
end
