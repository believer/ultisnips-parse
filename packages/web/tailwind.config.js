const colors = require("tailwindcss/colors");

module.exports = {
  purge: ["./src/**/*.bs.js"],
  darkMode: "media",
  theme: {
    extend: {
      colors: {
        coolGray: colors.coolGray,
      },
    },
  },
  variants: {
    typography: ["dark"],
  },
  plugins: [require("@tailwindcss/typography")],
  future: {
    purgeLayersByDefault: true,
    removeDeprecatedGapUtilities: true,
  },
};
