class Goenv < Formula
  desc "Go version management"
  homepage "https://github.com/go-nv/goenv"
  url "https://github.com/go-nv/goenv/archive/refs/tags/2.2.18.tar.gz"
  sha256 "3739f7379798b3e2670ec09fd5f946b235dcec09ff6dd7c3141b2dc9bf211590"
  license "MIT"
  version_scheme 1
  head "https://github.com/go-nv/goenv.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea97b916c280691524e36c8e00f899af38644514cf0c1cd4f756755378a3c10d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea97b916c280691524e36c8e00f899af38644514cf0c1cd4f756755378a3c10d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ea97b916c280691524e36c8e00f899af38644514cf0c1cd4f756755378a3c10d"
    sha256 cellar: :any_skip_relocation, sonoma:        "71113ddfe6e19afe102383f4c545e8e7107730e7633ba22d8d104c0c21cbb41b"
    sha256 cellar: :any_skip_relocation, ventura:       "71113ddfe6e19afe102383f4c545e8e7107730e7633ba22d8d104c0c21cbb41b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea97b916c280691524e36c8e00f899af38644514cf0c1cd4f756755378a3c10d"
  end

  def install
    inreplace_files = [
      "libexec/goenv",
      "plugins/go-build/install.sh",
      "test/goenv.bats",
      "test/test_helper.bash",
    ]
    inreplace inreplace_files, "/usr/local", HOMEBREW_PREFIX

    prefix.install Dir["*"]
    %w[goenv-install goenv-uninstall go-build].each do |cmd|
      bin.install_symlink "#{prefix}/plugins/go-build/bin/#{cmd}"
    end
  end

  test do
    assert_match "Usage: goenv <command> [<args>]", shell_output("#{bin}/goenv help")
  end
end
