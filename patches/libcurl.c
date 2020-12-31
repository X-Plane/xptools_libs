/* This is a dummy stub for libcurl.so, based on the idea in

   https://blog.gibson.sh/2017/11/26/creating-portable-linux-binaries/#how-and-why-libcurl-uses-symbol-versioning

   Its purpose is to get rid of symbol versioning used in the system libcurl. Compile with 

   gcc -shared -fpic -o libcurl.so libcurl.c 

   which makes our own (disfunctional) libcurl.so, which has unversioned symbols.
   Then link WED link against it without providing an explicit path, e.g. by using

   -L./libs/local$(MULTI_SUFFIX)/lib -lcurl

   At runtime, ldd will resolve against the real system libcurl and it will all work out,
   repardless of the system libcurl having symbol versioning or not.
*/

typedef void CURL;
typedef enum { X } CURLcode;
typedef enum { Y } CURLoption;
struct curl_slist;

CURL * curl_easy_init(void)
{ return 0; }

CURLcode curl_easy_setopt(CURL * curl, CURLoption option, ...)
{ return 0; }

CURLcode curl_easy_perform(CURL * curl)
{ return 0; }

void curl_easy_cleanup(CURL * curl)
{ return; }

CURLcode curl_easy_getinfo(CURL * curl, CURLoption option, long * code)
{ return 0; }

const char * curl_easy_strerror(CURLcode code)
{ return 0; }

void curl_slist_free_all(struct curl_slist * slist)
{ return; }

struct curl_slist * curl_slist_append(struct curl_slist * slist, const char * c)
{ return 0; }


/* the same concept can also be used to prevent depending on GLIBC_2.29 when building
   on Ubuntu 20.04. This glib version adds optimized math functions and even AVX/FMA versions
   and the runtime linker knows which flavour to pick on any given CPU. 

   Using unversioned symbols here are benefical over using the "old" glibc_2.2.5 version numbers,
   as users with a new glibc version will now benefit from having these highly optimized 
   versions available. And it really doesn't matter at all that these functions are normally
   provided by libm.so. The linker chooses the version-suffix used for any function as per the
   first library that it encounters with the matching symbol in them. And the library name itself
   isn't part of the symbol information.

   But (there is always something, right ?) there are some know bugs in the gnu ld linker.
   Which cause this trick to not work when 
   - compiler intrinsic __builiin functions exist for any given function
   - and -flto is used
   There is no known workaround, but either NOT using -flto or not the gnu linker.
   So there comes the google 'gold' linker: It has no problems here, its faster than
   the gnu linker and its available on pretty much all linux distros. Its ABI functions 
   are 100% compatible with the gu linker - so we only have to use it when linking these
   'highly portable binaries'.
*/

float  powf(float x, float y) { return 0.0; }
double pow(double x, double y) { return 0.0; }
double log(double x) { return 0.0; }
double exp(double x) { return 0.0; }
double exp2(double x) { return 0.0; }

/* An alternate, less desireable option is to include the following explicit 
   versioning requests in all source files, i.e. by including this in Xdefs.h
   But we can 'unversion' this way - as the linker will require an unversioned 
   matching symbol in the library, which isn't available.
   Its also inherently not working with -flto, as there is no assembler running 
   at compile time.

#if LIN
  __asm__(".symver powf  powf@GLIBC_2.2.5");
  __asm__(".symver pow,  pow@GLIBC_2.2.5");
  __asm__(".symver exp,  exp@GLIBC_2.2.5");
  __asm__(".symver exp2, exp2@GLIBC_2.2.5");
  __asm__(".symver log,  log@GLIBC_2.2.5");
#endif

*/
