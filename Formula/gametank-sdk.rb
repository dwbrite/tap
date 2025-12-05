class GametankSdk < Formula
  desc "GameTank SDK - Complete toolkit for GameTank development"
  homepage "https://github.com/dwbrite/gametank-sdk"
  version "0.14.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.14.0/gametank-sdk-aarch64-apple-darwin.tar.xz"
      sha256 "758456dbdfef6b14c12af59ce5c37c3ad92b67d14b34cd7ff199f39348f3940e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.14.0/gametank-sdk-x86_64-apple-darwin.tar.xz"
      sha256 "4eb772d3b62470532ef1ba74d2677613b98eb237d3b80d933f8b9a84255c7e95"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.14.0/gametank-sdk-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "0a43dfea0eca4ea79a0ccbb9995a3ebaf49723422d1e6689ef018638a61d06ed"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.14.0/gametank-sdk-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "90e5af6ee5cb7080cbb515f12c4072ef411c28d61d4152d6417cb737c3ffbfd4"
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
