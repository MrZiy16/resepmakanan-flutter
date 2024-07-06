const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendNotificationOnNewRecipe = functions.firestore
    .document("kuliner/{recipeId}")
    .onCreate(async (snap, context) => {
      const newValue = snap.data();

      const payload = {
        notification: {
          title: "Resep Baru!",
          body: `Resep baru ditambahkan: ${newValue.nama}`,
          clickAction: "FLUTTER_NOTIFICATION_CLICK",
        },
        data: {
          type: "new_recipe",
          recipeId: context.params.recipeId,
        },
      };

      try {
        const response = await admin.messaging().sendToTopic("new_recipes", payload);
        console.log("Notification sent successfully:", response);
      } catch (error) {
        console.log("Error sending notification:", error);
      }
    });
