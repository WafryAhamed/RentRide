/** @type {import('tailwindcss').Config} */
export default {
  content: [
    "./index.html",
    "./src/**/*.{js,ts,jsx,tsx}",
  ],
  theme: {
    extend: {
      colors: {
        primary: "#ffcc00", // RentRide Yellow
        dark: "#121212",
        "dark-card": "#1E1E1E",
        "dark-border": "#333333"
      }
    },
  },
  plugins: [],
}
