class LlmOrchestra < Formula
  include Language::Python::Virtualenv

  desc "Multi-agent LLM communication system with ensemble orchestration"
  homepage "https://github.com/mrilikecoding/llm-orc"
  url "https://github.com/mrilikecoding/llm-orc/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "e7f32b6e790ce06b18275199f25d84b9985f116028aa46e16ab71f50c3e52f47"
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