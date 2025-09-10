module.exports = {
  content: [
    "./js/**/*.{js,ts}",
    "./css/**/*.{css}",
    "../lib/*_web.ex",
    "../lib/*_web/**/*.*ex",
    "../lib/*_web/**/*.heex"
  ],
  darkMode: 'class',
  theme: { extend: {} },
  plugins: [require("@tailwindcss/typography")], // remove if you didn’t install it
}