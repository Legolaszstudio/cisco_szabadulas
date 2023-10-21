String msToHumanStr(int ms) {
  int minutes = (ms / 60000).floor();
  int seconds = ((ms % 60000) / 1000).floor();
  return minutes.toString().padLeft(2, '0') +
      ':' +
      seconds.toString().padLeft(2, '0');
}
