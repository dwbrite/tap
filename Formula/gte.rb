class Gte < Formula
  desc "gametank emulator"
  homepage "https://github.com/dwbrite/gametank-sdk"
  version "0.10.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/v0.10.1/gte-aarch64-apple-darwin.tar.xz"
      sha256 "b7022dbf925ec05bdbbb1a93c24e721ebd68bc9d030f92759d64b21ee4b5b1b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/v0.10.1/gte-x86_64-apple-darwin.tar.xz"
      sha256 "163bde248490e4f1b383f7378505fd9c0d4ec7cad4c87174b2ec80432c76b6ca"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/v0.10.1/gte-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "75bb9a48d6f875f8baf618dbe29dc6edf93ed1925a3aa4d4b0a9578664e810f5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/v0.10.1/gte-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2cad6270df151e8d584cb80060dfbd6a89029b449a295ee2c18299b8251fa3a6"
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
    bin.install "gte" if OS.mac? && Hardware::CPU.arm?
    bin.install "gte" if OS.mac? && Hardware::CPU.intel?
    bin.install "gte" if OS.linux? && Hardware::CPU.arm?
    bin.install "gte" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
