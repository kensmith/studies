#include <botan/botan.h>
#include <botan/rsa.h>
#include <iostream>
#include "log_t.hpp"

int main()
{
   Botan::LibraryInitializer init;
   Botan::AutoSeeded_RNG rng;
   Botan::RSA_PrivateKey key(rng, 2048);
   std::cout << Botan::X509::PEM_encode(key);
   std::cout << Botan::PKCS8::PEM_encode(key);
   return 0;
}
