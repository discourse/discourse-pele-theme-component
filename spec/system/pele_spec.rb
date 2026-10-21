# frozen_string_literal: true

RSpec.describe "Pele diagrams" do
  before { upload_theme_component }

  it "renders a diagram that opens fullscreen" do
    post = Fabricate(:post, raw: <<~MD)
      ```mermaid
      flowchart LR
        A --> B --> C --> D --> E --> F --> G --> H --> I --> J --> K --> L
      ```
    MD

    visit(post.url)

    expect(page).to have_css("#post_1 .pele-wrapper .pele-diagram__canvas svg.pele")
    expect(page).to have_no_css("#post_1 .pele-zoom", visible: :all)

    find("#post_1 .pele-wrapper").hover
    find("#post_1 .pele-wrapper__fullscreen").click

    expect(page).to have_css(".pele-fullscreen .pele-diagram__canvas svg.pele")
    expect(page).to have_css(".pele-fullscreen .pele-zoom")
  end

  it "shows an error for invalid source" do
    post = Fabricate(:post, raw: <<~MD)
      ```mermaid
      flowchart LR
        A -
      ```
    MD

    visit(post.url)

    expect(page).to have_css("#post_1 .pele-diagram__error")

    find("#post_1 .pele-wrapper").hover
    expect(page).to have_no_css("#post_1 .pele-wrapper__fullscreen")
  end
end
