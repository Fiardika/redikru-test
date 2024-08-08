export default [
  {
    ignores: ["node_modules/**"],
  },
  {
    files: ["**/*.js"],
    languageOptions: {
      ecmaVersion: 12,
      globals: {
        require: "readonly",
        describe: "readonly",
        it: "readonly",
      },
    },
    rules: {
      "no-undef": "off",
    },
  },
];
