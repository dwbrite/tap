class GametankSdk < Formula
  desc "GameTank SDK - Complete toolkit for GameTank development"
  homepage "https://github.com/dwbrite/gametank-sdk"
  version "0.12.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.12.0/gametank-sdk-aarch64-apple-darwin.tar.xz"
      sha256 "4ffebf7be5e20a7c39fe6bbc8146021a6bf75604e1f437a77f0c5aa42fc242fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.12.0/gametank-sdk-x86_64-apple-darwin.tar.xz"
      sha256 "b6322ee955323764752864eebedb0b48a03bd16c16ba26d172b1e58a8260fac5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.12.0/gametank-sdk-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "145f614af0e5e768a32f6b56cc338fcdf8353b463bc52ecdd3cd27b4448e6f74"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.12.0/gametank-sdk-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8ad2a645885953aba5c1235275e50329cd78c01fd96c562ad352a1d936074bf5"
    end
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "gte", "gtgo", "gtld", "gtrom" if OS.mac? && Hardware::CPU.arm?
    bin.install "gte", "gtgo", "gtld", "gtrom" if OS.mac? && Hardware::CPU.intel?
    bin.install "gte", "gtgo", "gtld", "gtrom" if OS.linux? && Hardware::CPU.arm?
    bin.install "gte", "gtgo", "gtld", "gtrom" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
