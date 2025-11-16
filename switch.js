var windows = workspace.windowList();
for (var i = 0; i < windows.length; ++i) {
  var w = windows[i];
  if (w.captionNormal == "$TARGET") {
    w.minimized = false;
    w.keepAbove = true;
  } else if (w.resourceClass == "steam_app_8500") {
    w.minimized = true;
    w.keepAbove = false;
  }
}
