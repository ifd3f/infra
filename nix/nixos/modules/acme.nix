{ config, lib, ... }:
{
  security.acme = {
    acceptTerms = true;
    defaults.email = "astrid@astrid.tech";
  };
}
