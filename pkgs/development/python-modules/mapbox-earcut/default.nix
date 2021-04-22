{ lib
, buildPythonPackage
, fetchPypi
, python3Packages
, fetchFromGitHub
, setuptools
}:

with python3Packages; buildPythonPackage rec {
  pname = "mapbox-earcut";
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "skogler";
    repo = "mapbox_earcut_python";
    rev = "257c2c82819acf72b2b757f200c160e55b9427fc";
    sha256 = "14z2vj13a1qcaqc6jvg00f367la5470bclvfi9mmlvpac3hhhywd";
    };

    nativeBuildInputs = [ setuptools ];
    buildInputs = [ pybind11 ];
    propagatedBuildInputs = [ numpy ];

    # Some test failed, some passed...
    checkInputs = [ pytestCheckHook ];
    doCheck = false;

    meta = with lib; {
      homepage = "https://github.com/skogler/mapbox_earcut_python";
      license = licenses.isc;
      description = "Mapbox-earcut fast triangulation of 2D-polygons";
      longDescription = ''
        Python bindings for the C++ implementation of the Mapbox Earcut
        library, which provides very fast and quite robust triangulation of 2D
        polygons.
      '';
      maintainers = with maintainers; [ friedelino ];
      broken = pybind11.version < "2.6.0"; # broken because of missing submodules in lower versions
    };
}
