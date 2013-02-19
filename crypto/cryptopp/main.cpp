#include <cryptopp/osrng.h>
#include <cryptopp/secblock.h>
#include <cryptopp/rsa.h>

int main()
{
   CryptoPP::AutoSeededRandomPool rng;
#if 0
   CryptoPP::InvertibleRSAFunction params;
   params.GenerateRandomWithKeySize(rng, 2048);
   CryptoPP::RSA::PrivateKey priv(params);
   CryptoPP::RSA::PublicKey pub(params);
#else
   CryptoPP::RSA::PrivateKey priv;
   priv.GenerateRandomWithKeySize(rng, 2048);
   CryptoPP::RSA::PublicKey pub(priv);
   CryptoPP::SavePrivateKey("private.pem", priv);
   CryptoPP::SavePublicKey("public.pem", pub);
#endif

   return 0;
}
