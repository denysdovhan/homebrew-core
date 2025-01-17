class FernApi < Formula
  desc "Stripe-level SDKs and Docs for your API"
  homepage "https://buildwithfern.com/"
  url "https://registry.npmjs.org/fern-api/-/fern-api-0.50.6.tgz"
  sha256 "954315cb6a1fc63be61efbe4d0bd8d0d94b695f7e068cc861d932166ab3ab694"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c9da7b1dd34404bad6cef32a6718f82ced1f341f162f865eacfe8d79abaa232e"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"fern", "init", "--docs", "--org", "brewtest"
    assert_path_exists testpath/"fern/docs.yml"
    assert_match "\"organization\": \"brewtest\"", (testpath/"fern/fern.config.json").read

    system bin/"fern", "--version"
  end
end
