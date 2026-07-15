// D:\accounting_Arya\mobile_app\customer_app\web\firebase-messaging-sw.js
importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js');

// تنظیمات اختصاصی پروژه شما
const firebaseConfig = {
  apiKey: "AIzaSyCUxCxPE1Dbs7aXoEL9p9R_M6Puhb0F73c",
  authDomain: "accounting-arya.firebaseapp.com",
  projectId: "accounting-arya",
  storageBucket: "accounting-arya.firebasestorage.app",
  messagingSenderId: "746712254012",
  appId: "1:746712254012:web:f93b68c5779f93e6056539",
  measurementId: "G-MQTB50BK4N"
};

firebase.initializeApp(firebaseConfig);
const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);

  const notificationTitle = payload.notification?.title || 'پیام جدید';
  const notificationOptions = {
    body: payload.notification?.body || 'شما یک پیام جدید دارید.',
    icon: '/icons/Icon-192.png',
    badge: '/icons/Icon-192.png'
  };

  // بروزرسانی Badge روی آیکون PWA وقتی اپلیکیشن در پس‌زمینه است
  if (navigator.setAppBadge) {
    // فرض بر این است که بک‌اند شما تعداد پیام نخوانده را در دیتا می‌فرستد. 
    // اگر نمی‌فرستد، موقتا عدد 1 ثبت می‌شود.
    const badgeCount = parseInt(payload.data?.badge || '1', 10);
    navigator.setAppBadge(badgeCount).catch(console.error);
  }

  return self.registration.showNotification(notificationTitle, notificationOptions);
});
