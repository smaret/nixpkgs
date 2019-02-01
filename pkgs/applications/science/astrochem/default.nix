{ stdenv, fetchurl, fetchFromGitHub, pythonPackages, sundials, autoconf, automake, gfortran, libtool, hdf5 }:

stdenv.mkDerivation rec {

  name = "astrochem";

  src = fetchFromGitHub {
    owner = "smaret";
    repo = "astrochem";
    rev = "e2a5f0d34b060983f86a6aa7acbf854970c4cb4f";
    sha256 = "0fg2rl3ika3qy55g1svcjcrki0ls2sdqaymbsk6pbilsk51qmq0p";
  };

  sundials2 = sundials.overrideAttrs (oldAttrs: rec {
    name = "sundials-2.7.0";
    src = fetchurl {
      url = "https://computation.llnl.gov/projects/sundials/download/sundials-2.7.0.tar.gz";
      sha256 = "01513g0j7nr3rh7hqjld6mw0mcx5j9z9y87bwjc16w2x2z3wm7yk";
    };
  });

  nativeBuildInputs = [ autoconf automake gfortran libtool ];

  buildInputs = [
    pythonPackages.python
    hdf5
    sundials2
  ];

  propagatedBuildInputs = [
    pythonPackages.numpy
    pythonPackages.h5py
    pythonPackages.cython
  ];

  preConfigure = "./bootstrap";

  # Not sure if that's needed.
  passthru = { pythonPath = []; };
}
