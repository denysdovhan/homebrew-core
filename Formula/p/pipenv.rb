class Pipenv < Formula
  include Language::Python::Virtualenv

  desc "Python dependency management tool"
  homepage "https://github.com/pypa/pipenv"
  url "https://files.pythonhosted.org/packages/0f/e5/e6b5e40a553f453c890b0253f559608cc0af1b7ae0e295095304061c699f/pipenv-2024.0.0.tar.gz"
  sha256 "e5ed842dc69b601da6fe26aee8677da608ec9df0f3f98c25442fdade5f1114ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d30d2b5eb4d230a6fb2accb076b53af6ee1a6816f92df41a74efc08b62aea13c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ce0cf201547b6982108929eca74cc82a074dcd88f94ab0fdd3f1078074fdffe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e56a0056fb62896bf6a35a05884b0732d16f90c63893e6bebaf507e0f03f1876"
    sha256 cellar: :any_skip_relocation, sonoma:         "a1fe87c478c5acf8e10932bcf83e0d04c74866acdbea642c94af06943836055d"
    sha256 cellar: :any_skip_relocation, ventura:        "97993ccf189c2c38417eccd1ca8008b24e0b58e3fa1a6a4ff0566b4adde62bf8"
    sha256 cellar: :any_skip_relocation, monterey:       "3e542eb02a44905c0127196dea12a7096f70584b0d3d760cbf04b30512906af6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5fd351c948333e6ba72b61c841166c96f3fb7faa411ecbf2e73dd9e9f2e44f1"
  end

  depends_on "certifi"
  depends_on "python@3.12"

  def python3
    "python3.12"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/c4/91/e2df406fb4efacdf46871c25cde65d3c6ee5e173b7e5a4547a47bae91920/distlib-0.3.8.tar.gz"
    sha256 "1530ea13e350031b6312d8580ddb6b27a104275a31106523b8f123787f494f64"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/06/ae/f8e03746f0b62018dcf1120f5ad0a1db99e55991f2cda0cf46edc8b897ea/filelock-3.14.0.tar.gz"
    sha256 "6ea72da3be9b8c82afd3edcf99f2fffbb5076335a5ae4d03248bb5b6c3eae78a"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/f5/52/0763d1d976d5c262df53ddda8d8d4719eedf9594d046f117c25a27261a19/platformdirs-4.2.2.tar.gz"
    sha256 "38b7b51f512eed9e84a22788b4bce1de17c0adb134d6becb09836e37d8654cd3"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/aa/60/5db2249526c9b453c5bb8b9f6965fcab0ddb7f40ad734420b3b421f7da44/setuptools-70.0.0.tar.gz"
    sha256 "f211a66637b8fa059bb28183da127d4e86396c991a942b028c6650d4319c3fd0"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/44/5a/cabd5846cb550e2871d9532def625d0771f4e38f765c30dc0d101be33697/virtualenv-20.26.2.tar.gz"
    sha256 "82bf0f4eebbb78d36ddaee0283d43fe5736b53880b8a8cdcd37390a07ac3741c"
  end

  def install
    virtualenv_install_with_resources

    generate_completions_from_executable(libexec/"bin/pipenv", shells:                 [:fish, :zsh],
                                                               shell_parameter_format: :click)
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    assert_match "Commands", shell_output("#{bin}/pipenv")
    system bin/"pipenv", "--python", which(python3)
    system bin/"pipenv", "install", "requests"
    system bin/"pipenv", "install", "boto3"
    assert_predicate testpath/"Pipfile", :exist?
    assert_predicate testpath/"Pipfile.lock", :exist?
    assert_match "requests", (testpath/"Pipfile").read
    assert_match "boto3", (testpath/"Pipfile").read
  end
end
