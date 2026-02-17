class LlmOrchestra < Formula
  include Language::Python::Virtualenv

  desc "Multi-agent LLM communication system with ensemble orchestration"
  homepage "https://github.com/mrilikecoding/llm-orc"
  url "https://github.com/mrilikecoding/llm-orc/archive/refs/tags/v0.14.2.tar.gz"
  sha256 "ed61b7ec5ff245040f0303d1ac1d8e510b77a795f118bf03a4ba3d7671ff57ca"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Create venv and install package with all dependencies
    system "#{Formula["python@3.12"].opt_bin}/python3.12", "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--upgrade", "pip", "setuptools", "wheel"
    system libexec/"bin/pip", "install", "."
    bin.install_symlink libexec/"bin/llm-orc"

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
