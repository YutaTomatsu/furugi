const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { onDocumentCreated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
admin.initializeApp();

// 1) プッシュ通知 (すでに v2 になっている例)
exports.sendPushNotification = onDocumentCreated(
  "notifications/{notificationId}",
  async (event) => {
    const snap = event.data;
    const notification = snap.data();

    // 通知対象ユーザーのトークンを取得
    const userRef = notification.user;
    const userSnap = await userRef.get();
    const userData = userSnap.data();
    const fcmToken = userData.fcmToken; // ユーザーの FCM トークンを事前に保存していると仮定

    if (fcmToken) {
      const payload = {
        notification: {
          title: notification.detail,
          body: "新しい通知があります。",
        },
      };

      try {
        await admin.messaging().sendToDevice(fcmToken, payload);
        console.log("通知送信成功");
      } catch (error) {
        console.error("通知送信失敗:", error);
      }
    } else {
      console.log("FCM トークンが見つかりません");
    }
  }
);

// 2) Stripe関連
const stripe = require("stripe")(
  "sk_test_51QDLEkDCX7s7s38MwLgTtYrD6kuRU223oao938xWCO0CdsiCMKYOn2CmqrJ6hCUFdphH3Ht7WkYUmazXlpKQSGG000C8aW8dzi"
);

exports.createPaymentIntent = onCall(async (request) => {
  // v2 onCallでは request.data にパラメータが入っている
  const { amount, currency } = request.data || {};

  if (!amount || !currency) {
    throw new HttpsError(
      "invalid-argument",
      "Amount or currency not provided."
    );
  }

  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount,
      currency,
    });
    return { clientSecret: paymentIntent.client_secret };
  } catch (error) {
    throw new HttpsError("internal", error.message);
  }
});

// 3) Nodemailer (メール送信)
const nodemailer = require("nodemailer");

// 本来はアプリパスワードの使用を推奨
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "tmtoto313@gmail.com",
    pass: "fmdblpkyzafopivx", // ここは本来「アプリパスワード」推奨
  },
});

exports.sendPurchaseMail = onCall(async (request) => {
  const { buyerEmail, sellerEmail } = request.data || {};

  if (!buyerEmail || !sellerEmail) {
    throw new HttpsError(
      "invalid-argument",
      "buyerEmail or sellerEmail not provided."
    );
  }

  // 購入者へのメール送信
  const mailOptionsForBuyer = {
    from: "tmtoto313@gmail.com",
    to: buyerEmail,
    subject: "購入完了のお知らせ",
    text: "ご購入ありがとうございます。商品が購入されました。",
  };
  await transporter.sendMail(mailOptionsForBuyer);

  // 出品者へのメール送信
  const mailOptionsForSeller = {
    from: "tmtoto313@gmail.com",
    to: sellerEmail,
    subject: "商品購入通知",
    text: "あなたの出品した商品が購入されました。",
  };
  await transporter.sendMail(mailOptionsForSeller);

  return { success: true };
});
