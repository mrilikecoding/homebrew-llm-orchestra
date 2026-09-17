class LlmOrchestra < Formula
  desc "Multi-agent LLM communication system with ensemble orchestration"
  homepage "https://github.com/mrilikecoding/llm-orc"
  url "https://github.com/mrilikecoding/llm-orc/archive/refs/tags/v0.20.4.tar.gz"
  sha256 "ab3c52dd1acaa67ed86735b40a7a8cd2713c618b89c216788fd0f7e7be98cfac"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Create venv and install package with all dependencies
    system "#{Formula["python@3.12"].opt_bin}/python3.12", "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--upgrade", "pip", "setuptools", "wheel"
    pip_args = ["install"]
    if Hardware::CPU.intel?
      # cryptography>=49 publishes no macOS x86_64 wheel; building it from
      # source needs a Rust toolchain that has no Intel bottle either
      # (hours from source). Stay on the last wheel. llm-orc's constraint
      # cryptography>=50 answers PYSEC-2026-3552, a PKCS#7 EnvelopedData
      # decryption oracle; llm-orc only uses Fernet, so that code path is
      # never reached. Revisit if a wheel or a rust bottle appears.
      (buildpath/"intel-constraints.txt").write "cryptography<49\n"
      pip_args += ["-c", buildpath/"intel-constraints.txt"]
    end
    system libexec/"bin/pip", *pip_args, "."
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
