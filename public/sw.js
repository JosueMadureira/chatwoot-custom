/* eslint-disable no-restricted-globals, no-console */
/* globals clients */
self.addEventListener('push', event => {
  let notification = event.data && event.data.json();

  let title = notification.title || 'New message';
  let body = notification.body || '';
  let icon = notification.avatar_url || '/android-chrome-192x192.png';
  let tag = notification.tag || `conversation-${notification.conversation_id}`;

  event.waitUntil(
    self.registration.showNotification(title, {
      tag: tag,
      icon: icon,
      body: body,
      data: {
        url: notification.url,
        conversation_id: notification.conversation_id,
        account_id: notification.account_id,
        inbox_id: notification.inbox_id,
        contact_name: notification.contact_name,
        notification_type: notification.notification_type
      },
    })
  );
});

self.addEventListener('notificationclick', event => {
  let notification = event.notification;

  event.waitUntil(
    clients.matchAll({ type: 'window' }).then(windowClients => {
      let matchingWindowClients = windowClients.filter(
        client => client.url === notification.data.url
      );

      if (matchingWindowClients.length) {
        let firstWindow = matchingWindowClients[0];
        if (firstWindow && 'focus' in firstWindow) {
          firstWindow.focus();
          return;
        }
      }
      if (clients.openWindow) {
        clients.openWindow(notification.data.url);
      }
    })
  );
});
