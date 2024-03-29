#BE_QUIET	:= > /dev/null 2>&1

# http://www.cgal.org/
VER_CGAL	:= 4.14.1
CGAL_URL    := https://github.com/CGAL/cgal/releases/download/releases%2FCGAL-4.14.1/CGAL-4.14.1.tar.xz
# http://www.freetype.org/
# http://sourceforge.net/projects/freetype/files/
VER_FREETYPE	:= 2.3.11
# http://trac.osgeo.org/proj/
VER_LIBPROJ	:= 4.7.0
# http://trac.osgeo.org/geotiff/
VER_GEOTIFF	:= 1.4.2
# http://www.ijg.org/
# http://www.ijg.org/files/
VER_LIBJPEG	:= 9a
# http://www.libpng.org/
# http://www.libpng.org/pub/png/libpng.html
VER_LIBPNG	:= 1.2.41
# http://www.libtiff.org/
# ftp://ftp.remotesensing.org/pub/libtiff
VER_LIBTIFF	:= 4.0.3
# http://shapelib.maptools.org/
# http://dl.maptools.org/dl/shapelib/
VER_LIBSHP	:= 1.2.10
# http://code.google.com/p/libsquish/
# http://code.google.com/p/libsquish/downloads/list
VER_LIBSQUISH	:= 1.10
# http://www.boost.org/
VER_BOOST	:= 1_71_0
BOOST_SHORTVER	:= 1_71
BOOST_URL   := https://boostorg.jfrog.io/artifactory/main/release/1.71.0/source/boost_1_71_0.tar.gz
# http://www.mesa3d.org/
# http://sourceforge.net/projects/mesa3d/files/
VER_MESA	:= 7.5
# http://expat.sourceforge.net/
# http://sourceforge.net/projects/expat/files/
VER_LIBEXPAT	:= 2.0.1
# http://gmplib.org/
# http://gmplib.org/#DOWNLOAD
VER_LIBGMP	:= 6.1.2
# http://www.mpfr.org/
# http://www.mpfr.org/mpfr-current/#download
VER_LIBMPFR	:= 4.0.2

PLATFORM	:= $(shell uname)
ifneq (, $(findstring MINGW, $(PLATFORM)))
	PLATFORM	:= Mingw
	PLAT_MINGW	:= Yes
endif

ifeq ($(cross), mingw64)
ifdef PLAT_MINGW
	MULTI_SUFFIX	:= 64
	CROSSPREFIX	:= x86_64-w64-mingw32-
	CROSSHOST	:= x86_64-w64-mingw32
else
	cross		:= ""
endif
else
ifdef PLAT_MINGW
	MULTI_SUFFIX	:=
#	CROSSPREFIX	:= i686-w64-mingw32-
#	CROSSHOST	:= i686-w64-mingw32
else
	cross		:= ""
endif
endif

DEFAULT_PREFIX		:= $(CURDIR)/local$(MULTI_SUFFIX)
DEFAULT_LIBDIR		:= $(DEFAULT_PREFIX)/lib
DEFAULT_INCDIR		:= $(DEFAULT_PREFIX)/include

MACOS_MIN_VERSION := 10.11
ifeq ($(PLATFORM), Darwin)
	PLAT_DARWIN := Yes
	DEFAULT_MACARGS	:= -mmacosx-version-min="$(MACOS_MIN_VERSION)" -arch x86_64 -arch arm64
	DEFAULT_MACARGS += -isysroot `xcrun --sdk macosx --show-sdk-path`
	VIS	:= -fvisibility=hidden
endif
ifeq ($(PLATFORM), Linux)
	PLAT_LINUX := Yes
	VIS	:= -fvisibility=hidden
endif

# boost
ARCHIVE_BOOST		:= boost_$(VER_BOOST).tar.gz

# mesa headers
ARCHIVE_MESA		:= mesa-headers-$(VER_MESA).tar.gz

# libgmp
ARCHIVE_LIBGMP		:= gmp-$(VER_LIBGMP).tar.xz
CFLAGS_LIBGMP		:= "$(DEFAULT_MACARGS) -I$(DEFAULT_INCDIR) -O2 $(VIS)"
CXXFLAGS_LIBGMP		:= "$(DEFAULT_MACARGS) -I$(DEFAULT_INCDIR) -O2 $(VIS)"
LDFLAGS_LIBGMP		:= "-L$(DEFAULT_LIBDIR)"
CONF_LIBGMP		:= --prefix=$(DEFAULT_PREFIX)
CONF_LIBGMP		+= --enable-shared=no
CONF_LIBGMP		+= --enable-cxx
# no assembler code
ifdef PLAT_DARWIN
# Ben turned off to fix bug in WED
#CONF_LIBGMP		+= --enable-fat
CONF_LIBGMP		+= --host=none-apple-darwin
endif
ifdef PLAT_MINGW
CONF_LIBGMP		+= --host=none-pc-mingw32
#CONF_LIBGMP		+= --host=$(CROSSHOST)
endif
ifdef PLAT_LINUX
CONF_LIBGMP		+= --host=none-pc-linux-gnu
endif

# libmpfr
ARCHIVE_LIBMPFR		:= mpfr-$(VER_LIBMPFR).tar.gz
CFLAGS_LIBMPFR		:= "$(DEFAULT_MACARGS) -I$(DEFAULT_INCDIR) -O2 $(VIS)"
LDFLAGS_LIBMPFR		:= "-L$(DEFAULT_LIBDIR)"
CONF_LIBMPFR		:= --prefix=$(DEFAULT_PREFIX)
CONF_LIBMPFR		+= --libdir=$(DEFAULT_LIBDIR)
CONF_LIBMPFR		+= --enable-shared=no
CONF_LIBMPFR		+= --disable-dependency-tracking
ifdef PLAT_MINGW
CONF_LIBMPFR		+= --host=$(CROSSHOST)
endif

# libexpat
ARCHIVE_LIBEXPAT	:= expat-$(VER_LIBEXPAT).tar.gz
CFLAGS_LIBEXPAT		:= "$(DEFAULT_MACARGS) -I$(DEFAULT_INCDIR) -O2 $(VIS)"
LDFLAGS_LIBEXPAT	:= "-L$(DEFAULT_LIBDIR)"
CONF_LIBEXPAT		:= --prefix=$(DEFAULT_PREFIX)
CONF_LIBEXPAT		+= --libdir=$(DEFAULT_LIBDIR)
CONF_LIBEXPAT		+= --enable-shared=no
ifdef PLAT_MINGW
CONF_LIBEXPAT		+= --host=$(CROSSHOST)
endif

# libpng
ARCHIVE_LIBPNG		:= libpng-$(VER_LIBPNG).tar.gz
CFLAGS_LIBPNG		:= "$(DEFAULT_MACARGS) -I$(DEFAULT_INCDIR) -O2 $(VIS)"
LDFLAGS_LIBPNG		:= "-L$(DEFAULT_LIBDIR)"
CONF_LIBPNG		:= --prefix=$(DEFAULT_PREFIX)
CONF_LIBPNG		+= --libdir=$(DEFAULT_LIBDIR)
CONF_LIBPNG		+= --enable-shared=no
CONF_LIBPNG		+= --disable-dependency-tracking
CONF_LIBPNG		+= CCDEPMODE="depmode=none"
ifdef PLAT_MINGW
CONF_LIBPNG		+= --host=$(CROSSHOST)
endif

# freetype
ARCHIVE_FREETYPE	:= freetype-$(VER_FREETYPE).tar.gz
CFLAGS_FREETYPE		:= "$(DEFAULT_MACARGS) -I$(DEFAULT_INCDIR) -O2 $(VIS)"
LDFLAGS_FREETYPE	:= "-L$(DEFAULT_LIBDIR)"
CONF_FREETYPE		:= --prefix=$(DEFAULT_PREFIX)
CONF_FREETYPE		+= --libdir=$(DEFAULT_LIBDIR)
CONF_FREETYPE		+= --enable-shared=no
CONF_FREETYPE		+= --with-zlib
ifdef PLAT_MINGW
CONF_FREETYPE		+= --host=$(CROSSHOST)
endif

# libjpeg
ARCHIVE_LIBJPEG		:= jpeg-$(VER_LIBJPEG).tar.gz
CC_LIBJPEG		:= "$(CROSSPREFIX)gcc"
CFLAGS_LIBJPEG		:= "$(DEFAULT_MACARGS) -I$(DEFAULT_INCDIR) -O2 $(VIS)"
LDFLAGS_LIBJPEG		:= "-L$(DEFAULT_LIBDIR)"
CONF_LIBJPEG		:= --prefix=$(DEFAULT_PREFIX)
CONF_LIBJPEG		+= --libdir=$(DEFAULT_LIBDIR)
CONF_LIBJPEG		+= --disable-dependency-tracking
CONF_LIBJPEG		+= --enable-shared=no
ifdef PLAT_MINGW
CONF_LIBJPEG		+= --host=$(CROSSHOST)
endif

# libtiff
ARCHIVE_LIBTIFF		:= tiff-$(VER_LIBTIFF).tar.gz
CXXFLAGS_LIBTIFF	:= "$(DEFAULT_MACARGS) -I$(DEFAULT_INCDIR) -O2 $(VIS)"
ifdef PLAT_DARWIN
CFLAGS_LIBTIFF		:= "$(DEFAULT_MACARGS) -I$(DEFAULT_INCDIR) -O2 -DHAVE_APPLE_OPENGL_FRAMEWORK=1 $(VIS)"
else
CFLAGS_LIBTIFF		:= "-I$(DEFAULT_INCDIR) -O2 $(VIS)"
endif
LDFLAGS_LIBTIFF		:= "-L$(DEFAULT_LIBDIR)"
CONF_LIBTIFF		:= --prefix=$(DEFAULT_PREFIX)
CONF_LIBTIFF		+= --libdir=$(DEFAULT_LIBDIR)
CONF_LIBTIFF		+= --enable-shared=no
CONF_LIBTIFF		+= --disable-dependency-tracking
CONF_LIBTIFF		+= --disable-lzma
CONF_LIBTIFF		+= --disable-jbig
CONF_LIBTIFF		+= --with-jpeg-include-dir=$(DEFAULT_INCDIR)
CONF_LIBTIFF		+= --with-jpeg-lib-dir=$(DEFAULT_LIBDIR)
CONF_LIBTIFF		+= --with-zlib
CONF_LIBTIFF		+= CCDEPMODE="depmode=none"
ifdef PLAT_DARWIN
CONF_LIBTIFF		+= --with-apple-opengl-framework
endif
ifdef PLAT_MINGW
CONF_LIBTIFF		+= --host=$(CROSSHOST)
endif

# libproj
ARCHIVE_LIBPROJ		:= proj-$(VER_LIBPROJ).tar.gz
CFLAGS_LIBPROJ		:= "$(DEFAULT_MACARGS) -I$(DEFAULT_INCDIR) -O2 $(VIS)"
LDFLAGS_LIBPROJ		:= "-L$(DEFAULT_LIBDIR)"
CONF_LIBPROJ		:= --prefix=$(DEFAULT_PREFIX)
CONF_LIBPROJ		+= --libdir=$(DEFAULT_LIBDIR)
CONF_LIBPROJ		+= --enable-shared=no
CONF_LIBPROJ		+= --disable-dependency-tracking
CONF_LIBPROJ		+= CCDEPMODE="depmode=none"
ifdef PLAT_MINGW
CONF_LIBPROJ		+= --without-mutex
CONF_LIBPROJ		+= --host=$(CROSSHOST)
endif

# geotiff
ARCHIVE_GEOTIFF		:= libgeotiff-$(VER_GEOTIFF).tar.gz
AR_GEOTIFF		:= "$(CROSSPREFIX)ar"
LD_GEOTIFF		:= "$(CROSSPREFIX)ld"
CFLAGS_GEOTIFF		:= "$(DEFAULT_MACARGS) -I$(DEFAULT_INCDIR) -O2 $(VIS)"
LDFLAGS_GEOTIFF		:= "-L$(DEFAULT_LIBDIR)"
CONF_GEOTIFF		:= --prefix=$(DEFAULT_PREFIX)
CONF_GEOTIFF		+= --libdir=$(DEFAULT_LIBDIR)
CONF_GEOTIFF		+= --enable-shared=no
CONF_GEOTIFF		+= --with-zip
CONF_GEOTIFF		+= --with-jpeg=$(DEFAULT_PREFIX)
CONF_GEOTIFF		+= --with-libtiff=$(DEFAULT_PREFIX)
CONF_GEOTIFF		+= --with-proj=$(DEFAULT_PREFIX)
CONF_GEOTIFF		+= --enable-incode-epsg
ifdef PLAT_MINGW
CONF_GEOTIFF		+= --host=$(CROSSHOST)
CONF_GEOTIFF		+= --target=$(CROSSHOST)
endif

# libcgal
ARCHIVE_CGAL		:= CGAL-$(VER_CGAL).tar.xz
CONF_CGAL		:= -DCGAL_CXX_FLAGS="$(VIS) -I$(DEFAULT_INCDIR)"
CONF_CGAL		+= -DCMAKE_INSTALL_PREFIX=$(DEFAULT_PREFIX)
CONF_CGAL		+= -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=FALSE
CONF_CGAL		+= -DCMAKE_INSTALL_LIBDIR=lib
CONF_CGAL		+= -DCGAL_MODULE_LINKER_FLAGS=-L$(DEFAULT_LIBDIR)
#CONF_CGAL               += -DCGAL_SHARED_LINKER_FLAGS=-L$(DEFAULT_LIBDIR)
CONF_CGAL               += -DCGAL_EXE_LINKER_FLAGS=-L$(DEFAULT_LIBDIR)
CONF_CGAL               += -DGMP_INCLUDE_DIR=$(DEFAULT_INCDIR)
CONF_CGAL               += -DGMP_LIBRARIES_DIR=$(DEFAULT_LIBDIR)
CONF_CGAL               += -DGMP_LIBRARIES=$(DEFAULT_LIBDIR)/libgmp.a
CONF_CGAL               += -DGMPXX_INCLUDE_DIR=$(DEFAULT_INCDIR)
CONF_CGAL               += -DGMPXX_LIBRARIES=$(DEFAULT_LIBDIR)/libgmpxx.a
CONF_CGAL               += -DMPFR_INCLUDE_DIR=$(DEFAULT_INCDIR)
CONF_CGAL               += -DMPFR_LIBRARIES_DIR=$(DEFAULT_LIBDIR)
CONF_CGAL               += -DMPFR_LIBRARIES=$(DEFAULT_LIBDIR)/libmpfr.a
CONF_CGAL               += -DWITH_CGAL_ImageIO=OFF -DWITH_CGAL_PDB=OFF 
CONF_CGAL               += -DWITH_CGAL_Qt3=OFF -DWITH_CGAL_Qt4=OFF -DWITH_CGAL_Qt5=OFF
CONF_CGAL               += -DBoost_INCLUDE_DIR=$(DEFAULT_INCDIR)
CONF_CGAL               += -DBOOST_LIBRARYDIR=$(DEFAULT_LIBDIR)
CONF_CGAL               += -DBOOST_USE_STATIC_LIBS=ON
CONF_CGAL               += -DBOOST_ROOT=$(DEFAULT_PREFIX)
ifdef PLAT_DARWIN
CONF_CGAL		+= -DCMAKE_OSX_SYSROOT=`xcrun --sdk macosx --show-sdk-path`
CONF_CGAL               += -DCMAKE_OSX_DEPLOYMENT_TARGET="$(MACOS_MIN_VERSION)"
CONF_CGAL               += -DCMAKE_OSX_ARCHITECTURES="x86_64 -arch arm64"
endif

# libsquish
ARCHIVE_LIBSQUISH	:= squish-$(VER_LIBSQUISH).tar.gz
CONF_LIBSQUISH		:= INSTALL_DIR=$(DEFAULT_PREFIX)
#CONF_LIBSQUISH		+= CPPFLAGS="$(DEFAULT_MACARGS) -DSQUISH_USE_SSE=2 -I$(DEFAULT_INCDIR) $(VIS)"
CONF_LIBSQUISH		+= CPPFLAGS="$(DEFAULT_MACARGS) -I$(DEFAULT_INCDIR) $(VIS)"
CONF_LIBSQUISH		+= AR="$(CROSSPREFIX)ar" CXX="$(CROSSPREFIX)g++"
CONF_LIBSQUISH		+= CXXFLAGS="-O3"

# libshp
ARCHIVE_LIBSHP		:= shapelib-$(VER_LIBSHP).tar.gz
CONF_LIBSHP		:= CFLAGS="$(DEFAULT_MACARGS) $(VIS)"

ifdef PLAT_LINUX
EXTRA_LIB := libcurl
endif

# targets
.PHONY: all all_wed clean directories boost mesa_headers libpng libfreetype libjpeg \
libtiff libproj libgeotiff libcgal libsquish libshp libexpat libgmp libmpfr libcurl

all_wed: directories \
libpng libjpeg libtiff libproj libgeotiff libsquish libfreetype libexpat $(EXTRA_LIB)
	@echo "done making libraries for WED and other xptools except Renderfarm"
	@echo "use 'make all' to also make libraries for RF like Boost, CGAL"

all: all_wed boost mesa_headers libcgal libshp libgmp libmpfr
	@echo "done making boost, cgal and other Renderfarm only dependencies"

clean:
	@echo "cleaning 3rd-party libraries, removing `pwd`/local"
	@-rm -rf ./local
	@-rm -rf ./local32 ./local64
	@-rm -rf ./tiff-* ./squish-* ./proj-* ./libgeotiff-* ./CGAL-*

directories:
	@-[ -d "./local$(MULTI_SUFFIX)/include" ] || mkdir -p "./local$(MULTI_SUFFIX)/include"
	@-[ -d "./local$(MULTI_SUFFIX)/lib" ] || mkdir -p "./local$(MULTI_SUFFIX)/lib"

boost: ./local$(MULTI_SUFFIX)/lib/.xpt_boost
./local$(MULTI_SUFFIX)/lib/.xpt_boost:
	@echo "downloading boost..."
	@curl -Lo "./archives/$(ARCHIVE_BOOST)" "$(BOOST_URL)"
	@echo "building boost..."
	@-rm -rf "boost_$(VER_BOOST)"
	@-mkdir "boost_$(VER_BOOST)"
	@tar -xzf "./archives/$(ARCHIVE_BOOST)"
ifdef PLAT_DARWIN
	@cd "boost_$(VER_BOOST)" && \
	chmod +x bootstrap.sh && \
	./bootstrap.sh --prefix=$(DEFAULT_PREFIX) --with-libraries=system,thread \
	--libdir=$(DEFAULT_PREFIX)/lib $(BE_QUIET) && \
	./b2 link=static cxxflags="$(VIS) $(DEFAULT_MACARGS)" $(BE_QUIET) && \
	./b2 install $(BE_QUIET)
	@cd local/lib && \
	rm -f *.dylib*
endif
ifdef PLAT_LINUX
	@cd "boost_$(VER_BOOST)" && \
	chmod +x bootstrap.sh && \
	./bootstrap.sh --prefix=$(DEFAULT_PREFIX) --with-libraries=system,thread \
	--libdir=$(DEFAULT_PREFIX)/lib $(BE_QUIET) && \
	./b2 cxxflags="$(VIS)" $(BE_QUIET) && \
	./b2 install $(BE_QUIET)
	@cd local/lib && \
	rm -f *.so*
endif
ifdef PLAT_MINGW
	@cp patches/0001-boost-tss-mingw.patch "boost_$(VER_BOOST)" && \
	cd "boost_$(VER_BOOST)" && \
	patch -p1 < ./0001-boost-tss-mingw.patch $(BE_QUIET) && \
	b2.exe install --toolset=gcc --prefix=$(DEFAULT_PREFIX) \
	--libdir=$(DEFAULT_PREFIX)/lib --with-thread $(BE_QUIET)
	@cd local/include && \
	ln -sf boost-$(BOOST_SHORTVER)/boost boost $(BE_QUIET) && \
	rm -rf boost-$(BOOST_SHORTVER)
	@cd local/lib && \
	ln -sf libboost_thread*-mt-$(BOOST_SHORTVER).a libboost_thread.a && \
	rm -f *.lib
endif
	@-rm -rf boost_$(VER_BOOST)
	@touch $@

mesa_headers: ./local$(MULTI_SUFFIX)/include/.xpt_mesa
./local$(MULTI_SUFFIX)/include/.xpt_mesa:
	@echo "extracting mesa headers..."
	@-mkdir -p "./local$(MULTI_SUFFIX)/include/mesa"
	@tar -C "./local$(MULTI_SUFFIX)/include/mesa" -xzf "./archives/$(ARCHIVE_MESA)"
	@touch $@

libexpat: ./local$(MULTI_SUFFIX)/lib/.xpt_libexpat
./local$(MULTI_SUFFIX)/lib/.xpt_libexpat:
	@echo "building libexpat..."
	@tar -xzf "./archives/$(ARCHIVE_LIBEXPAT)"
	@cd "expat-$(VER_LIBEXPAT)" && \
	chmod +x configure && \
	CFLAGS=$(CFLAGS_LIBEXPAT) LDFLAGS=$(LDFLAGS_LIBEXPAT) \
	./configure $(CONF_LIBEXPAT) $(BE_QUIET)
	@$(MAKE) -C "expat-$(VER_LIBEXPAT)" install $(BE_QUIET)
	@-rm -rf expat-$(VER_LIBEXPAT)
	@touch $@

libgmp: ./local$(MULTI_SUFFIX)/lib/.xpt_libgmp
./local$(MULTI_SUFFIX)/lib/.xpt_libgmp:
	@echo "building libgmp..."
	@tar -xf "./archives/$(ARCHIVE_LIBGMP)"
	@cd "gmp-$(VER_LIBGMP)" && \
	chmod +x configure && \
	CFLAGS=$(CFLAGS_LIBGMP) CXXFLAGS=$(CXXFLAGS_LIBGMP) LDFLAGS=$(LDFLAGS_LIBGMP) \
	./configure $(CONF_LIBGMP) $(BE_QUIET)
	@$(MAKE) -C "gmp-$(VER_LIBGMP)" install $(BE_QUIET)
	@-rm -rf gmp-$(VER_LIBGMP)
	@touch $@

libmpfr: ./local$(MULTI_SUFFIX)/lib/.xpt_libmpfr
./local$(MULTI_SUFFIX)/lib/.xpt_libmpfr: ./local$(MULTI_SUFFIX)/lib/.xpt_libgmp
	@echo "building libmpfr..."
	@tar -xzf "./archives/$(ARCHIVE_LIBMPFR)"
	@cd "mpfr-$(VER_LIBMPFR)" && \
	chmod +x configure && \
	CFLAGS=$(CFLAGS_LIBMPFR) LDFLAGS=$(LDFLAGS_LIBMPFR) \
	./configure $(CONF_LIBMPFR) $(BE_QUIET)
	@$(MAKE) -C "mpfr-$(VER_LIBMPFR)" install $(BE_QUIET)
	@-rm -rf mpfr-$(VER_LIBMPFR)
	@touch $@

libpng: ./local$(MULTI_SUFFIX)/lib/.xpt_libpng
./local$(MULTI_SUFFIX)/lib/.xpt_libpng:
	@echo "building libpng..."
	@tar -xzf "./archives/$(ARCHIVE_LIBPNG)"
	@cd "libpng-$(VER_LIBPNG)" && \
	chmod +x configure && \
	CFLAGS=$(CFLAGS_LIBPNG) LDFLAGS=$(LDFLAGS_LIBPNG) \
	./configure $(CONF_LIBPNG) $(BE_QUIET)
	@$(MAKE) -C "libpng-$(VER_LIBPNG)" install $(BE_QUIET)
	@-rm -rf libpng-$(VER_LIBPNG)
	@touch $@


libfreetype: ./local$(MULTI_SUFFIX)/lib/.xpt_libfreetype
./local$(MULTI_SUFFIX)/lib/.xpt_libfreetype:
	@echo "building libfreetype..."
	@tar -xzf "./archives/$(ARCHIVE_FREETYPE)"
	@cd "freetype-$(VER_FREETYPE)" && \
	chmod +x configure && \
	CFLAGS=$(CFLAGS_FREETYPE) LDFLAGS=$(LDFLAGS_FREETYPE) \
	./configure $(CONF_FREETYPE) $(BE_QUIET)
	@$(MAKE) -C "freetype-$(VER_FREETYPE)" install $(BE_QUIET)
	@-rm -rf freetype-$(VER_FREETYPE)
	@touch $@

libjpeg: ./local$(MULTI_SUFFIX)/lib/.xpt_libjpeg
./local$(MULTI_SUFFIX)/lib/.xpt_libjpeg:
	@echo "building libjpeg..."
	@tar -xzf "./archives/$(ARCHIVE_LIBJPEG)"
	@cd "jpeg-$(VER_LIBJPEG)" && \
	chmod +x configure && \
	CFLAGS=$(CFLAGS_LIBJPEG) LDFLAGS=$(LDFLAGS_LIBJPEG) CC=$(CC_LIBJPEG) \
	./configure $(CONF_LIBJPEG) $(BE_QUIET)
	@$(MAKE) -C "jpeg-$(VER_LIBJPEG)" install $(BE_QUIET)
	@-rm -rf jpeg-$(VER_LIBJPEG)
	@touch $@


libtiff: ./local$(MULTI_SUFFIX)/lib/.xpt_libtiff
./local$(MULTI_SUFFIX)/lib/.xpt_libtiff: ./local$(MULTI_SUFFIX)/lib/.xpt_libjpeg
	@echo "building libtiff..."
	@tar -xzf "./archives/$(ARCHIVE_LIBTIFF)"
	@cd "tiff-$(VER_LIBTIFF)" && \
	chmod +x configure && \
	CFLAGS=$(CFLAGS_LIBTIFF) CXXFLAGS=$(CXXFLAGS_LIBTIFF) LDFLAGS=$(LDFLAGS_LIBTIFF) \
	./configure $(CONF_LIBTIFF) $(BE_QUIET)
	@$(MAKE) -C "tiff-$(VER_LIBTIFF)" install $(BE_QUIET)
	@-rm -rf tiff-$(VER_LIBTIFF)
	@touch $@

libproj: ./local$(MULTI_SUFFIX)/lib/.xpt_libproj
./local$(MULTI_SUFFIX)/lib/.xpt_libproj:
	@echo "building libproj..."
	@tar -xzf "./archives/$(ARCHIVE_LIBPROJ)"
	@cd "proj-$(VER_LIBPROJ)" && \
	chmod +x configure && \
	CFLAGS=$(CFLAGS_LIBPROJ) LDFLAGS=$(LDFLAGS_LIBPROJ) \
	./configure $(CONF_LIBPROJ) $(BE_QUIET)
	@$(MAKE) -C "proj-$(VER_LIBPROJ)" $(BE_QUIET)
	@$(MAKE) -C "proj-$(VER_LIBPROJ)" -j1 install $(BE_QUIET)
	@-rm -rf proj-$(VER_LIBPROJ)
	@touch $@


libgeotiff: ./local$(MULTI_SUFFIX)/lib/.xpt_libgeotiff
./local$(MULTI_SUFFIX)/lib/.xpt_libgeotiff: ./local$(MULTI_SUFFIX)/lib/.xpt_libjpeg \
./local$(MULTI_SUFFIX)/lib/.xpt_libtiff ./local$(MULTI_SUFFIX)/lib/.xpt_libproj
	@echo "building libgeotiff..."
	@tar -xzf "./archives/$(ARCHIVE_GEOTIFF)"
	@patch -p0 <patches/0001-libgeotiff-1.4.2-incode.patch
ifeq ($(PLATFORM), Darwin)
	@patch -p0 <patches/0002-libgeotiff-1.4.2-python3.patch
endif
	@cd "libgeotiff-$(VER_GEOTIFF)" && \
	chmod +x configure && \
	CFLAGS=$(CFLAGS_GEOTIFF) LDFLAGS=$(LDFLAGS_GEOTIFF) \
	LD_SHARED=$(LD_GEOTIFF) AR=$(AR_GEOTIFF) \
	./configure $(CONF_GEOTIFF) $(BE_QUIET)
	@$(MAKE) -C "libgeotiff-$(VER_GEOTIFF)" -j1 $(BE_QUIET)
	@$(MAKE) -C "libgeotiff-$(VER_GEOTIFF)" install $(BE_QUIET)
	@-rm -rf libgeotiff-$(VER_GEOTIFF)
	@-rm -rf ./local/lib/libgeotiff.so*
	@touch $@


libsquish: ./local$(MULTI_SUFFIX)/lib/.xpt_libsquish
./local$(MULTI_SUFFIX)/lib/.xpt_libsquish:
	@echo "building libsquish..."
	@tar -xzf "./archives/$(ARCHIVE_LIBSQUISH)"
	@cp patches/0001-libsquish-gcc-4.3-header-fix.patch \
	"squish-$(VER_LIBSQUISH)" && cd "squish-$(VER_LIBSQUISH)" && \
	patch -p1 < ./0001-libsquish-gcc-4.3-header-fix.patch $(BE_QUIET)
	@cd "squish-$(VER_LIBSQUISH)" && \
	$(MAKE) $(CONF_LIBSQUISH) install $(BE_QUIET)
	@-rm -rf squish-$(VER_LIBSQUISH)
	@touch $@


libcgal: ./local$(MULTI_SUFFIX)/lib/.xpt_libcgal
./local$(MULTI_SUFFIX)/lib/.xpt_libcgal: \
./local$(MULTI_SUFFIX)/lib/.xpt_libgmp \
./local$(MULTI_SUFFIX)/lib/.xpt_libmpfr \
./local$(MULTI_SUFFIX)/lib/.xpt_boost
	@echo "downloading CGAL..."
	@curl -Lo "./archives/$(ARCHIVE_CGAL)" "$(CGAL_URL)"
	@echo "building libcgal..."
	@-mkdir "CGAL-$(VER_CGAL)"
	@tar -xJf "./archives/$(ARCHIVE_CGAL)" -C "CGAL-$(VER_CGAL)" --strip-components=1
	@cd "CGAL-$(VER_CGAL)" && \
	cmake . $(CONF_CGAL) $(BE_QUIET) && \
	make $(BE_QUIET) && make install $(BE_QUIET)
	@-rm -rf CGAL-$(VER_CGAL)
	@touch $@


libshp: ./local$(MULTI_SUFFIX)/lib/.xpt_libshp
./local$(MULTI_SUFFIX)/lib/.xpt_libshp:
	@echo "building libshp..."
	@tar -xzf "./archives/$(ARCHIVE_LIBSHP)"
	@cp patches/0001-libshp-fix-makefile-for-multiple-platforms.patch \
	"shapelib-$(VER_LIBSHP)" && cd "shapelib-$(VER_LIBSHP)" && \
	patch -p1 < ./0001-libshp-fix-makefile-for-multiple-platforms.patch $(BE_QUIET)
	@$(MAKE) -C "shapelib-$(VER_LIBSHP)" $(CONF_LIBSHP) lib $(BE_QUIET)
	@cp -Lp shapelib-$(VER_LIBSHP)/*.h ./local$(MULTI_SUFFIX)/include
	@cp shapelib-$(VER_LIBSHP)/.libs/libshp.a ./local$(MULTI_SUFFIX)/lib
	@-rm -rf shapelib-$(VER_LIBSHP)
	@touch $@

libcurl: ./local$(MULTI_SUFFIX)/lib/libcurl.so
./local$(MULTI_SUFFIX)/lib/libcurl.so: patches/libcurl.c
	@echo "building stub to unversion some math sybmols ..."
	@-mkdir -p "./local$(MULTI_SUFFIX)/lib"
	$(CC) -shared -fpic -Wl,-soname,libcurl.so.4 -o $@ $<
