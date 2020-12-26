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

