Name:           harbour-bibletime
Version:        3.28
Release:        0
Summary:        Bibletime mobile
License:        GPL-2.0
URL:            https://github.com/bibletime/bibletimemobile
Source:         %{name}-%{version}.tar.bz2
Requires:       qt-runner
Requires:       opt-qt5-qtdeclarative >= 5.15.8
Requires:       opt-qt5-qtsvg >= 5.15.8
Requires:       opt-qt5-qtscxml >= 5.15.8
Requires:       opt-qt5-qtquickcontrols2 >= 5.15.8
BuildRequires:  opt-qt5-qtdeclarative-devel >= 5.15.8
BuildRequires:  opt-qt5-qtsvg-devel >= 5.15.8
BuildRequires:  opt-qt5-qtscxml-devel >= 5.15.8
BuildRequires:  opt-qt5-qtquickcontrols2-devel >= 5.15.8
BuildRequires:  desktop-file-utils
%{?opt_qt5_default_filter}

%description

%prep
%autosetup -n %{name}-%{version}/src

%build
%{opt_qmake_qt5} SAILFISHOS=1
%make_build

%install
%qmake5_install

desktop-file-install --delete-original       \
  --dir %{buildroot}%{_datadir}/applications             \
   %{buildroot}%{_datadir}/applications/*.desktop


%files
%%defattr(-,root,root,-)
/usr/bin/%{name}
%{_datadir}/applications/%{name}.desktop
%{_datadir}/icons/hicolor/scalable/apps/bibletime.svg
%{_datadir}/icons/hicolor/128x128/apps/bibletime.png

%changelog
