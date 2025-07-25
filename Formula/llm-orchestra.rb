class LlmOrchestra < Formula
  include Language::Python::Virtualenv

  desc "Multi-agent LLM communication system with ensemble orchestration"
  homepage "https://github.com/mrilikecoding/llm-orc"
  url "https://github.com/mrilikecoding/llm-orc/archive/refs/tags/v0.8.1.tar.gz"
  sha256 "6222643328ae155091ec6674a73fc94e6f5d4e55fb32e01739d597dbb316c28c"
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