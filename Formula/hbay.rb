# hbay — Hugging Bay supply-chain CLI (Homebrew formula)
# Release asset: hbay-<version>.tar.gz built by apps/web/bin/release-build.mjs
# (deterministic tarball: bin/hbay.mjs + lib/eval-harness.mjs; checksums, SBOM,
# and provenance published alongside on the GitHub release).
# Tap: copy this file to barneywohl/homebrew-hbay at Formula/hbay.rb.

class Hbay < Formula
  desc "Hugging Bay supply-chain CLI: lock, restore, and dedup model artifacts"
  homepage "https://huggingbay.xyz"
  url "https://huggingbay.xyz/dl/hbay-0.1.0.tar.gz"
  version "0.1.0"
  sha256 "38bfa2905b82b97897ec7aed3ba0c94111735be4ff5b2f8508d1e57a17f48be0"
  license "MIT"

  depends_on "node"

  def install
    # Release tarball layout: bin/hbay.mjs + lib/eval-harness.mjs
    libexec.install Dir["*"]

    # Thin bin shim that execs the mjs entrypoint with the formula's Node.
    (bin/"hbay").write <<~SH
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/bin/hbay.mjs" "$@"
    SH
    chmod 0755, bin/"hbay"
  end

  test do
    assert_match "hbay", shell_output("#{bin}/hbay --help 2>&1", 0)
  end
end
