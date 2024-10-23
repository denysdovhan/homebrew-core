class Melange < Formula
  desc "Build APKs from source code"
  homepage "https://github.com/chainguard-dev/melange"
  url "https://github.com/chainguard-dev/melange/archive/refs/tags/v0.14.5.tar.gz"
  sha256 "31e4f6e37e07bad856508f0d1bab1211a8c2fef427603e555e89911460717e72"
  license "Apache-2.0"
  head "https://github.com/chainguard-dev/melange.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e6b1ff3fde3e474bade8f3ef8f03e72a7cb2baac7133e8769f8e70a765b07fe9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e6b1ff3fde3e474bade8f3ef8f03e72a7cb2baac7133e8769f8e70a765b07fe9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "e6b1ff3fde3e474bade8f3ef8f03e72a7cb2baac7133e8769f8e70a765b07fe9"
    sha256 cellar: :any_skip_relocation, sonoma:        "a501287f57f02d5e3d203af6c57128641f133bc586a8ba6216de5a0c51514710"
    sha256 cellar: :any_skip_relocation, ventura:       "a501287f57f02d5e3d203af6c57128641f133bc586a8ba6216de5a0c51514710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fbdb06d4b20bd9d712c668c631d2ca407604c3a2a833101aa94bcde7051d4023"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X sigs.k8s.io/release-utils/version.gitVersion=#{version}
      -X sigs.k8s.io/release-utils/version.gitCommit=brew
      -X sigs.k8s.io/release-utils/version.gitTreeState=clean
      -X sigs.k8s.io/release-utils/version.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"melange", "completion")
  end

  test do
    (testpath/"test.yml").write <<~EOS
      package:
        name: hello
        version: 2.12
        epoch: 0
        description: "the GNU hello world program"
        copyright:
          - paths:
            - "*"
            attestation: |
              Copyright 1992, 1995, 1996, 1997, 1998, 1999, 2000, 2001, 2002, 2005,
              2006, 2007, 2008, 2010, 2011, 2013, 2014, 2022 Free Software Foundation,
              Inc.
            license: GPL-3.0-or-later
        dependencies:
          runtime:

      environment:
        contents:
          repositories:
            - https://dl-cdn.alpinelinux.org/alpine/edge/main
          packages:
            - alpine-baselayout-data
            - busybox
            - build-base
            - scanelf
            - ssl_client
            - ca-certificates-bundle

      pipeline:
        - uses: fetch
          with:
            uri: https://ftp.gnu.org/gnu/hello/hello-${{package.version}}.tar.gz
            expected-sha256: cf04af86dc085268c5f4470fbae49b18afbc221b78096aab842d934a76bad0ab
        - uses: autoconf/configure
        - uses: autoconf/make
        - uses: autoconf/make-install
        - uses: strip
    EOS

    assert_equal "hello-2.12-r0", shell_output("#{bin}/melange package-version #{testpath}/test.yml")

    system bin/"melange", "keygen"
    assert_predicate testpath/"melange.rsa", :exist?

    assert_match version.to_s, shell_output(bin/"melange version 2>&1")
  end
end
