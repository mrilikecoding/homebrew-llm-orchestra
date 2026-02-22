class LlmOrchestra < Formula
  desc "Multi-agent LLM communication system with ensemble orchestration"
  homepage "https://github.com/mrilikecoding/llm-orc"
  url "https://github.com/mrilikecoding/llm-orc/archive/refs/tags/v0.15.4.tar.gz"
  sha256 "057e286852484874e523886ac49412c2a3417b7fee92865a490751e5392e65e4"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Create venv and install package with all dependencies
    system "#{Formula["python@3.12"].opt_bin}/python3.12", "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--upgrade", "pip", "setuptools", "wheel"
    system libexec/"bin/pip", "install", "."
    bin.install_symlink libexec/"bin/llm-orc"

    # Fix: Clear dylib IDs on all .so files to prevent Homebrew relocation
    # failures. Rust-compiled extensions (cryptography, jiter, etc.) have
    # insufficient Mach-O header padding for Cellar path rewriting.
    # Python loads these via dlopen, so they don't need a dylib ID.
    (libexec/"lib/python3.12/site-packages").glob("**/*.so").each do |so|
      system "install_name_tool", "-id", "", so
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
