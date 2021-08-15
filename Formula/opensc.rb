class Opensc < Formula
  desc "Tools and libraries for smart cards"
  homepage "https://github.com/OpenSC/OpenSC/wiki"
  url "https://github.com/OpenSC/OpenSC/releases/download/0.22.0/opensc-0.22.0.tar.gz"
  sha256 "8d4e5347195ebea332be585df61dcc470331c26969e4b0447c851fb0844c7186"
  license "LGPL-2.1-or-later"
  head "https://github.com/OpenSC/OpenSC.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 2
    sha256 arm64_big_sur: "885a597c41199253c351ca6ff2e74e37d4e185689aa39f13427c23f9c0ec230d"
    sha256 big_sur:       "c65a43909f56d856d4a3dea6ff2010d0f4933dd8508e6cc0ee1898884e802df9"
    sha256 catalina:      "483b47da8bd5a8339fc4dc6b2498b6c662cb0783801e5dfa2651602d7153fd86"
    sha256 mojave:        "32df51660a704109b38931903b89c88ca79e98ce806f83d59fff486275edfdab"
    sha256 x86_64_linux:  "f958a474641861b3a404dce4b482045a6ae7760ff3e4b8ad8d11b4164b07681c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "pcsc-lite"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-openssl
      --enable-pcsc
      --enable-sm
      --with-xsl-stylesheetsdir=#{Formula["docbook-xsl"].opt_prefix}/docbook-xsl
    ]

    system "./bootstrap"
    system "./configure", *args
    system "make", "install"
  end

  def caveats
    <<~EOS
      The OpenSSH PKCS11 smartcard integration will not work from High Sierra
      onwards. If you need this functionality, unlink this formula, then install
      the OpenSC cask.
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/opensc-tool -i")
  end
end
