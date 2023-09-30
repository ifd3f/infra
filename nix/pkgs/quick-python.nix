# Python environment with packages for quick prototyping
{ python3 }:
python3.withPackages (ps:
  with ps; [
    aiohttp
    beautifulsoup4
    black
    jupyter
    numpy
    pandas
    pillow
    pyyaml
    requests
    scipy
  ])
