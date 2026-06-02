class GametankSdk < Formula
  desc "GameTank SDK - Complete toolkit for GameTank development"
  homepage "https://github.com/dwbrite/gametank-sdk"
  version "0.17.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.17.1/gametank-sdk-aarch64-apple-darwin.tar.xz"
      sha256 "451caf086ecf0537c94e1efbe205502ead2faaeb0fbc21447be2d8315babca7c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.17.1/gametank-sdk-x86_64-apple-darwin.tar.xz"
      sha256 "71b171b2b23a03e5115eec9c2cafc7e6590aa4dc1864a54db1a64d820ba01025"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.17.1/gametank-sdk-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d2e247ee4b33792f8c27962ee6adf939bf7d10a90cdfd8af8afb58e150303166"
    end
    if Hardware::CPU.intel?
      url "https://github.com/dwbrite/gametank-sdk/releases/download/gametank-sdk-v0.17.1/gametank-sdk-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "598c2c2ebff0d621181679598ddf99ee3145d3e9fb78310eba3cbbbeab65d8b0"
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
