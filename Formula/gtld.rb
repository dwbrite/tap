class Gtld < Formula
  desc "GameTank Loader! For loading gametank roms onto 2M Flash cartridges using the Gametank Cartridge Programmer v4"
  homepage "https://github.com/dwbrite/gametank-sdk"
  version "0.10.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/v0.10.0/gtld-aarch64-apple-darwin.tar.xz"
      sha256 "32e282d9741c663a37dec965df97273f11c932fe4f4f4250370558e5efb2b5ad"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/v0.10.0/gtld-x86_64-apple-darwin.tar.xz"
      sha256 "2d90d72ae2e2f28e6e365a8f59548fb3109901a0e2a79dcc0124a2a8942f992b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/v0.10.0/gtld-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9da6bcd07a19a3ac2fe7b160fdaa9ea52176be5bf6816b810176f23bfa5cd0bb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/v0.10.0/gtld-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5794fb9944c0d3096a7024a011a7151deed8db08814386e050439d43030732d8"
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
    bin.install "gtld" if OS.mac? && Hardware::CPU.arm?
    bin.install "gtld" if OS.mac? && Hardware::CPU.intel?
    bin.install "gtld" if OS.linux? && Hardware::CPU.arm?
    bin.install "gtld" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
