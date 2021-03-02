const colors = require('tailwindcss/colors')

module.exports = {
  purge: ['./src/**/*.bs.js'],
  darkMode: 'media',
  theme: {
    extend: {
      colors: {
        coolGray: colors.coolGray,
      },
      typography: theme => ({
        dark: {
          css: {
            color: theme('colors.coolGray.100'),
            a: {
              color: theme('colors.indigo.400'),
              '&:hover': {
                color: theme('colors.indigo.400'),
              },
              code: {
                color: theme('colors.indigo.300'),
              },
            },

            strong: {
              color: theme('colors.gray.200'),
            },

            thead: {
              th: {
                color: theme('colors.gray.200'),
              },
            },

            h1: {
              color: theme('colors.coolGray.100'),
            },
            h2: {
              color: theme('colors.coolGray.100'),
            },
            h3: {
              color: theme('colors.coolGray.100'),
            },
            h4: {
              color: theme('colors.coolGray.100'),
            },
            h5: {
              color: theme('colors.coolGray.100'),
            },
            h6: {
              color: theme('colors.coolGray.100'),
            },

            code: {
              color: theme('colors.indigo.300'),
            },
            pre: {
              backgroundColor: theme('colors.coolGray.600'),
              color: theme('colors.coolGray.200'),
            },

            figcaption: {
              color: theme('colors.gray.500'),
            },
            '::selection': {
              backgroundColor: theme('colors.indigo.300'),
            },
          },
        },
      }),
    },
  },
  variants: {
    typography: ['dark'],
    extend: {
      ringWidth: ['hover', 'group-hover'],
      ringOffsetWidth: ['hover', 'group-hover'],
      ringColor: ['hover', 'group-hover'],
      ringOffsetColor: ['hover', 'group-hover'],
    },
  },
  plugins: [require('@tailwindcss/typography')],
  future: {
    purgeLayersByDefault: true,
    removeDeprecatedGapUtilities: true,
  },
}
