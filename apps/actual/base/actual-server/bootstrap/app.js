import runMigrations from "./src/migrations.js";
import finalConfig from "./src/load-config.js";
import { bootstrapPassword } from "./src/accounts/password.js";
import { enableOpenID } from "./src/account-db.js";

(async () => {
  try {
    await runMigrations();
    await bootstrapPassword(process.env.ACTUAL_PASSWORD);
    await enableOpenID(finalConfig);
    // Import the app here because initial migrations need to be run first - they are dependencies of the app.js
    const app = await import("./src/app.js");
    app.default(); // run the app
  } catch (err) {
    console.log("Error starting app:", err);
    process.exit(1);
  }
})();
