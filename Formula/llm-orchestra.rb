class LlmOrchestra < Formula
  include Language::Python::Virtualenv

  desc "Multi-agent LLM communication system with ensemble orchestration"
  homepage "https://github.com/mrilikecoding/llm-orc"
  url "https://github.com/mrilikecoding/llm-orc/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "2fb69ca669633fbf88613e1b1e5375d9ce8303a8bf2fd9bbd740d7d5cf479140"
  license "MIT"

  depends_on "python@3.12"

  def install
    system "#{Formula["python@3.12"].opt_bin}/python3.12", "-m", "venv", libexec
    system libexec/"bin/pip", "install", "--upgrade", "pip", "setuptools", "wheel"
    system libexec/"bin/pip", "install", "."
    bin.install_symlink libexec/"bin/llm-orc"
  end

  test do
    system "#{bin}/llm-orc", "--help"
    assert_match "llm orchestra", shell_output("#{bin}/llm-orc --help").downcase
  end
end