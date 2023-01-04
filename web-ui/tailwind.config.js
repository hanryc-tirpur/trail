module.exports = {
  mode: 'jit',
  purge: ['./index.html', './src/**/*.{js,ts,jsx,tsx}'],
  darkMode: 'media', // or 'media' or 'class'
  theme: {
    extend: {}
  },
  corePlugins: {
    // Remove Tailwind CSS's preflight style so it can use the MUI's preflight instead (CssBaseline).
    preflight: false,
  },
  screens: {},
  variants: {
    extend: {}
  },
  plugins: []
};
