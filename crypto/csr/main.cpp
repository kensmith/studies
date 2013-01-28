#include <botan/botan.h>
#include <botan/x509self.h>
#include <iostream>

int main()
{
   Botan::LibraryInitializer init;
   Botan::AutoSeeded_RNG rng;
   Botan::X509_Cert_Options opts;
   opts.common_name = "my client cert";
   opts.country = "US";
   opts.organization = "NMW";
   opts.email = "hi@there.com";
   Botan::Private_Key* key = Botan::PKCS8::load_key("private.pem", rng);
   Botan::PKCS10_Request csr = Botan::X509::create_cert_req(opts, *key, "SHA-256", rng);
   std::cout << csr.PEM_encode() << std::endl;

   return 0;
}
