class LlmOrchestra < Formula
  include Language::Python::Virtualenv

  desc "Multi-agent LLM communication system with ensemble orchestration"
  homepage "https://github.com/mrilikecoding/llm-orc"
  url "https://github.com/mrilikecoding/llm-orc/archive/refs/tags/v0.8.0.tar.gz"
  sha256 "e54e9d5aa6b8f3da346997ae388f7470d96f93334e6a96ad8423e2777c89122e"
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