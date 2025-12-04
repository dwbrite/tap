class Gtld < Formula
  desc "GameTank Loader! For loading gametank roms onto 2M Flash cartridges using the Gametank Cartridge Programmer v4"
  homepage "https://github.com/dwbrite/gametank-sdk"
  version "0.10.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/v0.10.1/gtld-aarch64-apple-darwin.tar.xz"
      sha256 "3a54978f1ab94b42789de03df3bc5a564e5473c7a757398a6ef84fb0b8ad88a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/v0.10.1/gtld-x86_64-apple-darwin.tar.xz"
      sha256 "6d5802db510f052b545faf4c6f521608607ca47d24e85106bbdcdb70c93d091c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/v0.10.1/gtld-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "cea1d93267e7a9dbcf68ad298a0691f1abdb8feb8ca6741476a306aeeac05e3f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/v0.10.1/gtld-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "babca6306cb24ae5f354713b9e643eddde187a98870d8a92688e9d8f3aefb3eb"
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
