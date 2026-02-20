class LlmOrchestra < Formula
  desc "Multi-agent LLM communication system with ensemble orchestration"
  homepage "https://github.com/mrilikecoding/llm-orc"
  url "https://github.com/mrilikecoding/llm-orc/archive/refs/tags/v0.14.4.tar.gz"
  sha256 "bbec0999d19f6495953208b1ab7112d2f63ea508ea6b20f8b16a2d64b60f5841"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Create venv and install package with all dependencies
    system "#{Formula["python@3.12"].opt_bin}/python3.12", "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--upgrade", "pip", "setuptools", "wheel"
    system libexec/"bin/pip", "install", "."
    bin.install_symlink libexec/"bin/llm-orc"

    # Fix: Clear dylib ID on cryptography's Rust .so to prevent Homebrew
    # relocation failures (header too small for Cellar paths).
    # The .so works fine without a dylib ID — Python loads it via dlopen.
    rust_so = libexec/"lib/python3.12/site-packages/cryptography/hazmat/bindings/_rust.abi3.so"
    if rust_so.exist?
      system "install_name_tool", "-id", "", rust_so
    end

    # Cleanup: Remove pip and wheel (keep setuptools due to .pth file)
    %w[pip wheel].each do |pkg|
      rm_rf libexec/"lib/python3.12/site-packages/#{pkg}"
    end

    # Cleanup: Remove test directories from dependencies (~4.5MB)
    (libexec/"lib/python3.12/site-packages").glob("*/tests").each(&:rmtree)

    # Cleanup: Remove compiled bytecode (~40MB, regenerates on first run)
    (libexec/"lib").glob("**/*.pyc").each(&:unlink)
    (libexec/"lib").glob("**/__pycache__").each(&:rmtree)
  end

  test do
    assert_match "llm orchestra", shell_output("#{bin}/llm-orc --help").downcase
  end
end
