class GametankSdk < Formula
  desc "GameTank SDK - Complete toolkit for GameTank development"
  homepage "https://github.com/dwbrite/gametank-sdk"
  version "0.15.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.15.0/gametank-sdk-aarch64-apple-darwin.tar.xz"
      sha256 "e28f464cb327abeda4dbe16146bea1831047d1cd95d2b2082a6bafd798176809"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.15.0/gametank-sdk-x86_64-apple-darwin.tar.xz"
      sha256 "7c347ac1b8838419185d168b1b848a9af8cd9b4b61324d4caa06050efd75f022"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.15.0/gametank-sdk-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "60a9ab4188055776a8cb10f2ed32cb6d5b73fea2e6e40b3deec2ae5eed3b86c8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.15.0/gametank-sdk-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3f01af271d67ee6b5ce38a8dd44e008b4102e51f468ce6270a5e0794d004e55f"
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
