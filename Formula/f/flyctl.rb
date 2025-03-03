class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.88",
      revision: "dc322ff991a7dcd99a20cbf70154a561c8a804b7"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85f6d6d00d3a245a3ca7f2b50d14468d865288efee5897ec27af329927f9f5bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "85f6d6d00d3a245a3ca7f2b50d14468d865288efee5897ec27af329927f9f5bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "85f6d6d00d3a245a3ca7f2b50d14468d865288efee5897ec27af329927f9f5bd"
    sha256 cellar: :any_skip_relocation, ventura:        "d00689df2dcdb84e22d1d9c6a231ae879e52e0dd9557e283ece5d8c218e60a29"
    sha256 cellar: :any_skip_relocation, monterey:       "d00689df2dcdb84e22d1d9c6a231ae879e52e0dd9557e283ece5d8c218e60a29"
    sha256 cellar: :any_skip_relocation, big_sur:        "d00689df2dcdb84e22d1d9c6a231ae879e52e0dd9557e283ece5d8c218e60a29"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "746274795a533626d86bab2a797ab41ea2d3098118e636c10eae2c1f32b07764"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
