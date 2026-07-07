{ lib }: with lib;
rec {
  accessPath =
    initial: path: if length path == 0 then initial else accessPath initial.${head path} (tail path);

  updatePath =
    initial: path: value:
    if length path == 0 then
      value
    else
      { "${head path}" = updatePath initial.${head path} (tail path) value; };
}
