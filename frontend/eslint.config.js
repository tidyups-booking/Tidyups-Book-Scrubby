// https://docs.expo.dev/guides/using-eslint/
const expoConfig = require("eslint-config-expo/flat");

module.exports = [
  {
    ignores: ["build/**", "**/build/**", "dist/**", "**/dist/**"],
  },
  ...expoConfig,
];
