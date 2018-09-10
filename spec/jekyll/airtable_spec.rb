require "spec_helper"

RSpec.describe Jekyll::Airtable do
  it "has a version number" do
    expect(Jekyll::Airtable::VERSION).not_to be nil
  end

  let(:site) { make_site }
  before { site.process }

  context "full page rendering" do
    let(:content) { File.read(dest_dir("page.html")) }

    # Specify what to display on the page.html
  end
end
