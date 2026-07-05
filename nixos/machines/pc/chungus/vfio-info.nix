let
  mkGpu =
    { video, audio }:
    {
      inherit video audio;
      pciDevs = [
        video
        audio
      ];
    };
in
{
  mainGpu = mkGpu {
    video = "10de:2482";
    audio = "10de:228b";
  };
  backupGpu = mkGpu {
    video = "10de:1cb6";
    audio = "10de:0fb9";
  };
}
