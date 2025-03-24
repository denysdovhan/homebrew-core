class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/47/fd/48835ffa0d70b8a861cf8986771dfdfc3245e9886e50e951a7500cad64db/pipdeptree-2.26.0.tar.gz"
  sha256 "9b8f3de54e87509a7e021d30bd39a1a6a1a45dce1489b8e785f2e90da06c3858"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "450a249f014ef208cafbeedba9e10f6dbd2cd251b15f9d1545b01d6230660cf6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "450a249f014ef208cafbeedba9e10f6dbd2cd251b15f9d1545b01d6230660cf6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "450a249f014ef208cafbeedba9e10f6dbd2cd251b15f9d1545b01d6230660cf6"
    sha256 cellar: :any_skip_relocation, sonoma:        "d89d83cc573b8535cb665825c9d05733dcaafb5bfa3185075b31eadac5401926"
    sha256 cellar: :any_skip_relocation, ventura:       "d89d83cc573b8535cb665825c9d05733dcaafb5bfa3185075b31eadac5401926"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "450a249f014ef208cafbeedba9e10f6dbd2cd251b15f9d1545b01d6230660cf6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "450a249f014ef208cafbeedba9e10f6dbd2cd251b15f9d1545b01d6230660cf6"
  end

  depends_on "python@3.13"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
