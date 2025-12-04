class GametankSdk < Formula
  desc "GameTank SDK - Complete toolkit for GameTank development"
  homepage "https://github.com/dwbrite/gametank-sdk"
  version "0.11.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.11.0/gametank-sdk-aarch64-apple-darwin.tar.xz"
      sha256 "0698ae89fb4d86d24442314b7b15e01ab5eede746735c27b095570717b757dbb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.11.0/gametank-sdk-x86_64-apple-darwin.tar.xz"
      sha256 "71e4dd7652a594e3ec4fa61a4171c8ae66820432135e440b3bf16d657ddfe7ad"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.11.0/gametank-sdk-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3d4a5178a45765e401faba2c78c58813800b7ebef6e0f9231966d08d32d3eb45"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.11.0/gametank-sdk-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "fadb5e50813e8f0c7d7bb9d76c2b12be7b18508e3997917d9f81395db982e5c5"
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
