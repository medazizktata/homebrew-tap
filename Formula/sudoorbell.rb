class Sudoorbell < Formula
  desc "Approve sudo from AI agents and other tools that have no terminal"
  homepage "https://github.com/medazizktata/sudoorbell"
  url "https://github.com/medazizktata/sudoorbell/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "838b3842a0054c30a76f40d845a8195d5d87c82b2473b291724a42014d473d5e"
  license "MIT"

  def install
    (libexec/"sudoorbell").install "bin", "lib", "libexec", "shell", "mcp"
    # The stable opt/ path, not this version's Cellar path, so the shell
    # startup blocks keep working across upgrades. SUDOORBELL_PACKAGED tells
    # `sudoorbell install` to use these files in place.
    (bin/"sudoorbell").write_env_script libexec/"sudoorbell/bin/sudoorbell",
      SUDOORBELL_PACKAGED: "1",
      SUDOORBELL_PREFIX:   opt_libexec/"sudoorbell"
  end

  def caveats
    <<~EOS
      Turn it on for your shells (adds a block to their startup files):
        sudoorbell install
      Options: --shell zsh,bash,fish,sh  --claude-deny  --claude-mcp
      Check the setup with:
        sudoorbell doctor
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/sudoorbell version")

    ENV["HOME"] = testpath
    ENV["XDG_CONFIG_HOME"] = testpath/".config"
    system bin/"sudoorbell", "install", "--shell", "zsh"
    assert_match "SUDOORBELL_HOME=\"#{opt_libexec}/sudoorbell\"", (testpath/".zshenv").read
    assert_path_exists libexec/"sudoorbell/libexec/sudoorbell-askpass"
    refute_path_exists testpath/".local/bin/sudoorbell"
  end
end
