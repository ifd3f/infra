# Packages

This directory contains packages and package helpers. Basically, if it requires a `pkgs` instance, then this directory will be working with it.

The dependency order is strictly as follows:

```
inputs.* -> self.overlays.* -> perSystem's pkgs -> self.packages.*
```

In other words, `self.packages` acts purely as a declaration of _exports_. Helpers for the rest of the flake MUST go inside the overlay.
