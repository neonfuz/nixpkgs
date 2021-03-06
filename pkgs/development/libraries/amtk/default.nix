{ stdenv, fetchurl
, pkgconfig, gnome3, dbus, xvfb_run }:
let
  version = "4.99.1";
  pname = "amtk";
in stdenv.mkDerivation {
  name = "${pname}-${version}";

  src = fetchurl {
    url = "mirror://gnome/sources/${pname}/${stdenv.lib.versions.majorMinor version}/${pname}-${version}.tar.xz";
    sha256 = "00fhvw5y638z584s8cfdslh47ngfzcgx4f0b0456sw8p754j3f8d";
  };

  nativeBuildInputs = [
    pkgconfig
    dbus
  ];

  buildInputs = [
    gnome3.gtk
  ];

  doCheck = stdenv.isLinux;
  checkPhase = ''
    export NO_AT_BRIDGE=1
    ${xvfb_run}/bin/xvfb-run -s '-screen 0 800x600x24' dbus-run-session \
      --config-file=${dbus.daemon}/share/dbus-1/session.conf \
      make check
  '';

  passthru.updateScript = gnome3.updateScript { packageName = pname; };

  meta = with stdenv.lib; {
    homepage = https://wiki.gnome.org/Projects/Amtk;
    description = "Actions, Menus and Toolbars Kit for GTK+ applications";
    maintainers = [ maintainers.manveru ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
}
