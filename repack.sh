#!/bin/bash -ex
# NB: This is the *server* version, which is not to be confused with the client library version.
# The important compatibility point is the *protocol* version, which hasn't changed in ages.
VERSION=10.6-1

cd `dirname $0`

PACKDIR=$(mktemp -d -t wat.XXXXXX)
LINUX_DIST=dist/postgresql-$VERSION-linux-x64-binaries.tar.gz
OSX_DIST=dist/postgresql-$VERSION-osx-binaries.zip
WINDOWS_DIST=dist/postgresql-$VERSION-win-binaries.zip

LINUX_BIN=$PWD/pgsql/lin
OSX_BIN=$PWD/pgsql/osx
WINDOWS_BIN=$PWD/pgsql/win


mkdir -p $LINUX_BIN -p $WINDOWS_BIN -p $OSX_BIN
[ -e $LINUX_DIST ] || wget -O $LINUX_DIST "http://get.enterprisedb.com/postgresql/postgresql-$VERSION-linux-x64-binaries.tar.gz"
[ -e $OSX_DIST ] || wget -O $OSX_DIST "http://get.enterprisedb.com/postgresql/postgresql-$VERSION-osx-binaries.zip"
[ -e $WINDOWS_DIST ] || wget -O $WINDOWS_DIST "http://get.enterprisedb.com/postgresql/postgresql-$VERSION-windows-x64-binaries.zip"

tar xzf $LINUX_DIST -C $PACKDIR
pushd $PACKDIR/pgsql
mkdir $LINUX_BIN/share
mkdir $LINUX_BIN/bin
mv share/postgresql $LINUX_BIN/share/postgresql
mv lib $LINUX_BIN/lib
mv bin/initdb $LINUX_BIN/bin/initdb
mv bin/pg_ctl $LINUX_BIN/bin/pg_ctl
mv bin/postgres $LINUX_BIN/bin/postgres
popd

rm -fr $PACKDIR && mkdir -p $PACKDIR

unzip -q -d $PACKDIR $OSX_DIST
pushd $PACKDIR/pgsql
mkdir $OSX_BIN/share
mkdir $OSX_BIN/lib
mkdir $OSX_BIN/lib/postgresql
mkdir $OSX_BIN/bin
mv share/postgresql $OSX_BIN/share/postgresql
mv lib/libicudata.57.dylib $OSX_BIN/lib/libicudata.57.dylib
mv lib/libicui18n.57.dylib $OSX_BIN/lib/libicui18n.57.dylib
mv lib/libicuuc.57.dylib $OSX_BIN/lib/libicuuc.57.dylib
mv lib/libxml2.2.dylib $OSX_BIN/lib/libxml2.2.dylib
mv lib/libssl.1.0.0.dylib $OSX_BIN/lib/libssl.1.0.0.dylib
mv lib/libcrypto.1.0.0.dylib $OSX_BIN/lib/libcrypto.1.0.0.dylib
mv lib/libuuid.1.1.dylib $OSX_BIN/lib/libuuid.1.1.dylib
mv lib/postgresql/*.so $OSX_BIN/lib/postgresql
mv bin/initdb $OSX_BIN/bin/initdb
mv bin/pg_ctl $OSX_BIN/bin/pg_ctl
mv bin/postgres $OSX_BIN/bin/postgres
popd

rm -fr $PACKDIR && mkdir -p $PACKDIR

unzip -q -d $PACKDIR $WINDOWS_DIST
pushd $PACKDIR/pgsql
mkdir $WINDOWS_BIN/lib
mkdir $WINDOWS_BIN/bin
mv share $WINDOWS_BIN
mv lib/iconv.lib $WINDOWS_BIN/lib/iconv.lib
mv lib/libxml2.lib $WINDOWS_BIN/lib/libxml2.lib
mv lib/ssleay32.lib $WINDOWS_BIN/lib/ssleay32.lib
mv lib/ssleay32MD.lib $WINDOWS_BIN/lib/ssleay32MD.lib
mv lib/*.dll $WINDOWS_BIN/lib/
mv bin/initdb.exe $WINDOWS_BIN/bin/initdb.exe
mv bin/pg_ctl.exe $WINDOWS_BIN/bin/pg_ctl.exe
mv bin/postgres.exe $WINDOWS_BIN/bin/postgres.exe
mv bin/*.dll $WINDOWS_BIN/bin/
popd

rm -rf $PACKDIR