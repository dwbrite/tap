class Gtrom < Formula
  desc "gametank rom management tool"
  homepage "https://github.com/dwbrite/gametank-sdk"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gtrom-v0.2.1/gtrom-aarch64-apple-darwin.tar.xz"
      sha256 "f835f972280ee5acbd1ee7d5172641eb28c43bcadc709239b9f06818ec07bf2f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gtrom-v0.2.1/gtrom-x86_64-apple-darwin.tar.xz"
      sha256 "90668601ba2ad46db88a2e68c6e12b879d115fb474de1ec7b26471560c465b54"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gtrom-v0.2.1/gtrom-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "02910e5961586a46014d4daca90511b41daef25fd95a9a68b90181316b5a74dd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gtrom-v0.2.1/gtrom-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8b6a0ffa06c8ae793aa36f91440d55705dffbc54760142b7511b93d72afc96a2"
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
    bin.install "gtrom" if OS.mac? && Hardware::CPU.arm?
    bin.install "gtrom" if OS.mac? && Hardware::CPU.intel?
    bin.install "gtrom" if OS.linux? && Hardware::CPU.arm?
    bin.install "gtrom" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
