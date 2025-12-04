class LlmOrchestra < Formula
  include Language::Python::Virtualenv

  desc "Multi-agent LLM communication system with ensemble orchestration"
  homepage "https://github.com/mrilikecoding/llm-orc"
  url "https://github.com/mrilikecoding/llm-orc/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "8581eaa9e7ce6f3bcbfe15184dfc3a6c3aa3ea699055d5e6e45213b8b7a4f213"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Create venv and install package with all dependencies
    system "#{Formula["python@3.12"].opt_bin}/python3.12", "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--upgrade", "pip", "setuptools", "wheel"
    system libexec/"bin/pip", "install", "."
    bin.install_symlink libexec/"bin/llm-orc"

    # Cleanup: Remove build tools (~21MB)
    %w[pip setuptools wheel pkg_resources _distutils_hack].each do |pkg|
      rm_rf libexec/"lib/python3.12/site-packages/#{pkg}"
    end

    # Cleanup: Remove dist-info metadata (~2MB)
    (libexec/"lib/python3.12/site-packages").glob("*.dist-info").each(&:rmtree)

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
