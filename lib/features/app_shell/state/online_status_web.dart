import 'dart:async';
import 'dart:html' as html;

Stream<bool> onlineStatusChanges() => Stream<bool>.multi((controller) {
  controller.add(html.window.navigator.onLine ?? true);
  final online = html.window.onOnline.listen((_) => controller.add(true));
  final offline = html.window.onOffline.listen((_) => controller.add(false));
  controller.onCancel = () {
    online.cancel();
    offline.cancel();
  };
});
