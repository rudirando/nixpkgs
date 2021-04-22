{ lib
, buildPythonPackage
, pkg-config
, fetchPypi
, cairo
, pango
, pygobject3
, glib
, libintl
, harfbuzz
, cython
, setuptools
, pytest
}:

buildPythonPackage rec {
  pname = "manimpango";
  version = "0.2.6";

  # doc/languages-frameworks/python.section.md: [..] Attribute names in
  # `python-packages.nix` as well as `pname`s should match the library's name
  # on PyPI, but be normalized according to [PEP
  # 0503](https://www.python.org/dev/peps/pep-0503/#normalized-names). This
  # means that characters should be converted to lowercase [..]
  src = fetchPypi {
    pname = "ManimPango";
    version = "0.2.6";
    sha256 = "64028b62b151bc80b047cc1757b27943498416dc4a85f073892a524b4d90ab41";
  };

  # inputs only needed during build
  nativeBuildInputs = [
    pkg-config
    setuptools
    cython
  ];

  # non-python deps
  buildInputs = [
    harfbuzz
    glib
    cairo
    libintl
    pango
  ];

  # python deps
  propagatedBuildInputs = [
    pygobject3
  ];

  setupPyBuildFlags = [
    "-I${cairo.dev}/include/cairo"
    "-L${cairo.out}/lib"
    "-lcairo"
    "-lpangocairo-1.0"
  ];

  # pangocairo is part of normal cairo-package, so remove corresponding deps
  # from setup.py
  patches = [ ./pangocairo.patch ];

  # checks fail until manim is installed
  doCheck = false;
  checkInputs = [ pytest ];
  checkPhase = ''
    pytest
  '';

  pythonImportsCheck = [ "manimpango" ];

  meta = with lib; {
    description = "ManimPango is a C binding for Pango using Cython";
    longDescription = ''
      ManimPango is a C binding for Pango using Cython, which is internally
      used in Manim to render (non-LaTeX) text.
    '';
    homepage = "https://github.com/ManimCommunity/ManimPango";
    license = licenses.gpl3;
    maintainers = with maintainers; [ friedelino ];
  };
}
